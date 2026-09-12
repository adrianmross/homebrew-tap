#!/usr/bin/env python3
"""Bump formulae in this tap to their upstream's latest release.

Why this exists: releasing a tool was only half done when its tag was pushed. The formula
here still pointed at the previous version until someone remembered to recompute sha256s by
hand, which was forgotten more than once.

Handles both shapes in this tap, because the rewrite is the same operation either way --
find every GitHub url, swap the version in it, and recompute the checksum that follows it:

  source archive (the Go tools, one url):
      url "https://github.com/<owner>/<repo>/archive/refs/tags/v1.2.3.tar.gz"
      sha256 "<64 hex>"

  release binaries (the cargo-dist tools, one url per platform):
      url "https://github.com/<owner>/<repo>/releases/download/v1.2.3/<asset>"
      sha256 "<64 hex>"

A formula is only touched when every url in it points at the same owner/repo/version. A
mixed formula is skipped rather than guessed at -- publishing a formula whose platforms
disagree about which version they are would be worse than leaving it stale.

Checksums always come from a real download of the exact asset the formula will point at,
never from API metadata, so a mismatch cannot be introduced by trusting the API.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import ssl
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

FORMULA_DIR = Path(__file__).resolve().parent.parent / "Formula"

# Both url shapes. The version is captured so it can be swapped wholesale; the rest of the
# path (asset name, platform triple) is preserved verbatim.
URL_RE = re.compile(
    r'^(?P<indent>[ \t]*)url[ \t]+"https://github\.com/(?P<owner>[\w.-]+)/(?P<repo>[\w.-]+)'
    r'/(?:archive/refs/tags/(?P<tag_a>v[^"/]+)\.tar\.gz'
    r'|releases/download/(?P<tag_b>v[^"/]+)/(?P<asset>[^"]+))"[ \t]*$',
    re.MULTILINE,
)
SHA_RE = re.compile(r'^(?P<indent>[ \t]*)sha256[ \t]+"(?P<sha>[0-9a-f]{64})"[ \t]*$', re.MULTILINE)
SEMVER_TAG_RE = re.compile(r"^v\d+\.\d+\.\d+$")


def ssl_context() -> ssl.SSLContext:
    """Default verification, with a certifi fallback for interpreters that ship no CA store
    (the python.org macOS builds). Verification is never disabled -- an unverifiable
    download would defeat the point of pinning a sha256."""
    ctx = ssl.create_default_context()
    if ctx.cert_store_stats().get("x509_ca", 0) == 0:
        try:
            import certifi

            ctx.load_verify_locations(cafile=certifi.where())
        except Exception:
            pass
    return ctx


def api(url: str) -> dict:
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    token = os.environ.get("GITHUB_TOKEN", "").strip()
    if token:  # rate limits only; this data is public
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30, context=ssl_context()) as resp:
        return json.load(resp)


def latest_stable_tag(owner: str, repo: str) -> str | None:
    """Newest published, non-draft, non-prerelease tag.

    /releases/latest already excludes drafts and prereleases, and 404s for a repo whose only
    releases are prereleases -- not an error worth failing the whole run over.
    """
    try:
        rel = api(f"https://api.github.com/repos/{owner}/{repo}/releases/latest")
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return None
        raise
    tag = str(rel.get("tag_name", "")).strip()
    # A tag scheme this cannot reason about is skipped rather than bumped to something odd.
    return tag if SEMVER_TAG_RE.match(tag) else None


def sha256_of(url: str) -> str:
    with urllib.request.urlopen(url, timeout=180, context=ssl_context()) as resp:
        digest = hashlib.sha256()
        for chunk in iter(lambda: resp.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def ruby_syntax_ok(source: str) -> bool | None:
    """True/False from `ruby -c`, or None when this ruby cannot judge the file at all.

    Baselined by the caller against the ORIGINAL formula. These use modern Ruby (3.1+
    shorthand hash syntax) while macOS ships 2.6, which rejects it -- treating that as a bad
    rewrite would block every correct bump on a developer machine.
    """
    try:
        proc = subprocess.run(["ruby", "-c", "-"], input=source, text=True, capture_output=True)
    except FileNotFoundError:
        return None
    return proc.returncode == 0


def retarget(url: str, current: str, latest: str) -> str:
    """Point a url at a new version.

    The version shows up in two places and only one is the path segment. cargo-dist names
    some assets with the version embedded (matrix-0.3.31-aarch64-apple-darwin.tar.gz) and
    others without (pump-aarch64-apple-darwin.tar.xz), so swapping just the
    /releases/download/<tag>/ segment silently produces a 404 for the former. Both the
    v-prefixed tag and the bare version are replaced; the bare pass runs second and cannot
    re-hit the already-updated segment because that now contains the NEW version.
    """
    out = url.replace(f"/{current}/", f"/{latest}/")
    out = out.replace(f"/{current}.", f"/{latest}.")  # archive/refs/tags/v1.2.3.tar.gz
    return out.replace(current.lstrip("v"), latest.lstrip("v"))


def url_exists(url: str) -> bool:
    """A guessed asset name that does not exist must fail loudly, not silently ship."""
    req = urllib.request.Request(url, method="HEAD")
    try:
        with urllib.request.urlopen(req, timeout=60, context=ssl_context()):
            return True
    except urllib.error.HTTPError:
        return False
    except urllib.error.URLError:
        return True  # transient network trouble is not proof the asset is missing


def bump(path: Path, apply: bool) -> tuple[str, str] | None:
    """Returns (old_tag, new_tag) when an update was available."""
    text = path.read_text()
    matches = list(URL_RE.finditer(text))
    if not matches:
        return None  # hand-shaped formula; not ours to touch

    owners = {(m["owner"], m["repo"]) for m in matches}
    tags = {m["tag_a"] or m["tag_b"] for m in matches}
    if len(owners) != 1 or len(tags) != 1:
        # Disagreeing urls mean this formula is not a simple version pin.
        print(f"  {path.name}: urls disagree on repo/version; skipping", file=sys.stderr)
        return None

    (owner, repo), current = owners.pop(), tags.pop()
    latest = latest_stable_tag(owner, repo)
    if not latest or latest == current:
        return None

    # Rebuild left to right so every url keeps its own indentation and asset name, and each
    # sha256 is matched to the url it actually follows rather than by position in the file.
    out: list[str] = []
    cursor = 0
    for m in matches:
        new_url = retarget(m.group(0).split('"')[1], current, latest)
        sha_m = SHA_RE.search(text, m.end())
        if not sha_m:
            raise RuntimeError(f"url at offset {m.start()} has no sha256 after it")
        # Nothing but whitespace/comments should sit between a url and its checksum.
        between = text[m.end() : sha_m.start()]
        if between.strip():
            raise RuntimeError("unexpected content between url and its sha256")

        out.append(text[cursor : m.start()])
        out.append(f'{m["indent"]}url "{new_url}"')
        out.append(between)
        if not url_exists(new_url):
            raise RuntimeError(f"asset not found after retargeting: {new_url}")
        out.append(f'{sha_m["indent"]}sha256 "{sha256_of(new_url)}"')
        cursor = sha_m.end()
    out.append(text[cursor:])
    updated = "".join(out)

    baseline = ruby_syntax_ok(text)
    if baseline is True and ruby_syntax_ok(updated) is False:
        raise RuntimeError("rewrite did not parse as ruby; not written")

    if apply:
        path.write_text(updated)
    return current, latest


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--check", action="store_true", help="report without writing")
    ap.add_argument("--only", help="limit to one formula stem, e.g. pump")
    args = ap.parse_args()

    changed: list[str] = []
    failed: list[str] = []
    for path in sorted(FORMULA_DIR.glob("*.rb")):
        if args.only and path.stem != args.only:
            continue
        try:
            result = bump(path, apply=not args.check)
        except Exception as exc:  # one bad upstream must not stop the rest
            print(f"  {path.name}: {type(exc).__name__}: {exc}", file=sys.stderr)
            failed.append(path.stem)
            continue
        if result:
            old, new = result
            print(f"  {path.stem}: {old} -> {new}")
            changed.append(f"{path.stem} {new.lstrip('v')}")

    # "nothing to do" and "could not tell" are different answers. Conflating them is how a
    # broken checker reports success forever, which an earlier version of this did.
    if failed:
        print(f"could not check: {', '.join(failed)}", file=sys.stderr)
        return 1

    if not changed:
        print("all formulae are current")
        return 0

    summary = ", ".join(changed)
    print(f"::notice::{summary}")
    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as fh:
            fh.write(f"changed=true\nsummary={summary}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
