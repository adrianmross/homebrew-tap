#!/usr/bin/env python3
"""Bump source-archive formulae in this tap to their upstream's latest release.

Why this exists: releasing one of the Go tools was only half done when its tag was
pushed. The formula here still pointed at the previous tarball, so `brew install` kept
serving the old version until someone remembered to compute a new sha256 by hand. That
step was forgotten more than once.

Scope is deliberately narrow. It only touches formulae whose url is a single GitHub
source tarball:

    url "https://github.com/<owner>/<repo>/archive/refs/tags/v1.2.3.tar.gz"
    sha256 "<64 hex>"

which is the shape every Go formula in this tap uses. The cargo-dist formulae (matrix,
ivm, pump, secretspec, proxyctl) carry several per-platform urls pointing at
releases/download, do not match, and are left alone -- cargo-dist generates those, and
guessing at multi-platform assets here would be a good way to publish a broken formula.

New formulae of the right shape are picked up automatically; there is no list to keep in
sync, which is the sort of thing that silently rots.

The sha256 is always computed from a real download of the exact tarball the formula will
point at. It is never copied from an API response, so a mismatch cannot be introduced by
trusting metadata.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import ssl
import urllib.error
import urllib.request
from pathlib import Path

FORMULA_DIR = Path(__file__).resolve().parent.parent / "Formula"

# Anchored on the archive path so releases/download urls (cargo-dist) cannot match.
URL_RE = re.compile(
    r'^(?P<indent>[ \t]*)url[ \t]+"https://github\.com/(?P<owner>[\w.-]+)/(?P<repo>[\w.-]+)'
    r'/archive/refs/tags/(?P<tag>v[^"]+)\.tar\.gz"[ \t]*$',
    re.MULTILINE,
)
SHA_RE = re.compile(r'^(?P<indent>[ \t]*)sha256[ \t]+"(?P<sha>[0-9a-f]{64})"[ \t]*$', re.MULTILINE)
SEMVER_TAG_RE = re.compile(r"^v\d+\.\d+\.\d+$")


def ssl_context() -> ssl.SSLContext:
    """Default verification, but fall back to certifi's bundle when the interpreter has
    no usable CA store -- common for python.org builds on macOS. Verification is never
    disabled; an unverifiable download would defeat the point of pinning a sha256.
    """
    ctx = ssl.create_default_context()
    if ctx.cert_store_stats().get("x509_ca", 0) == 0:
        try:
            import certifi

            ctx.load_verify_locations(cafile=certifi.where())
        except Exception:
            pass
    return ctx


def api(url: str) -> dict | list:
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    # Authenticated when available purely for rate limits; the data read here is public.
    token = os.environ.get("GITHUB_TOKEN", "").strip()
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30, context=ssl_context()) as resp:
        return json.load(resp)


def latest_stable_tag(owner: str, repo: str) -> str | None:
    """Newest published, non-draft, non-prerelease release tag.

    /releases/latest already excludes drafts and prereleases, but it 404s for a repo whose
    only releases are prereleases, so that is not an error worth failing on.
    """
    try:
        rel = api(f"https://api.github.com/repos/{owner}/{repo}/releases/latest")
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return None
        raise
    tag = str(rel.get("tag_name", "")).strip()
    # Guard against a tag scheme this script cannot reason about rather than
    # bumping to something unexpected.
    return tag if SEMVER_TAG_RE.match(tag) else None


def sha256_of(url: str) -> str:
    with urllib.request.urlopen(url, timeout=120, context=ssl_context()) as resp:
        digest = hashlib.sha256()
        for chunk in iter(lambda: resp.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def ruby_syntax_ok(source: str) -> bool | None:
    """True/False from `ruby -c`, or None when this ruby cannot judge the file at all.

    Deliberately baselined by the caller against the ORIGINAL formula. Homebrew formulae
    use modern Ruby -- the Go ones here use 3.1+ shorthand hash syntax (`ldflags:`) --
    while macOS still ships 2.6, which rejects them. Treating that as a bad rewrite would
    block every correct bump on a developer machine, so an unparseable baseline means
    "no opinion" rather than "broken".
    """
    try:
        proc = subprocess.run(
            ["ruby", "-c", "-"],
            input=source,
            text=True,
            capture_output=True,
        )
    except FileNotFoundError:
        return None  # no ruby here; not a reason to block a correct bump
    return proc.returncode == 0


def bump(path: Path, apply: bool) -> tuple[str, str] | None:
    """Returns (old_tag, new_tag) when an update is available."""
    text = path.read_text()
    url_match = URL_RE.search(text)
    if not url_match:
        return None  # cargo-dist or hand-shaped formula; not ours to touch

    owner = url_match["owner"]
    repo = url_match["repo"]
    current = url_match["tag"]

    latest = latest_stable_tag(owner, repo)
    if not latest or latest == current:
        return None

    new_url = f"https://github.com/{owner}/{repo}/archive/refs/tags/{latest}.tar.gz"
    new_sha = sha256_of(new_url)

    sha_match = SHA_RE.search(text, url_match.end())
    if not sha_match:
        print(f"  {path.name}: url matched but no sha256 followed it; skipping", file=sys.stderr)
        return None

    updated = text[: url_match.start()] + f'{url_match["indent"]}url "{new_url}"' + text[url_match.end() : sha_match.start()]
    updated += f'{sha_match["indent"]}sha256 "{new_sha}"' + text[sha_match.end() :]

    # Only meaningful if this ruby can parse the file we started from; see ruby_syntax_ok.
    baseline = ruby_syntax_ok(text)
    if baseline is True and ruby_syntax_ok(updated) is False:
        raise RuntimeError("rewrite did not parse as ruby; not written")

    if apply:
        path.write_text(updated)
    return current, latest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="report without writing")
    args = parser.parse_args()

    changed: list[str] = []
    failed: list[str] = []
    for path in sorted(FORMULA_DIR.glob("*.rb")):
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

    # "nothing to do" and "could not tell" are different answers, and conflating them is
    # how a broken checker reports success forever. Fail loudly instead.
    if failed:
        print(f"could not check: {', '.join(failed)}", file=sys.stderr)
        return 1

    if not changed:
        print("all source-archive formulae are current")
        return 0

    summary = ", ".join(changed)
    print(f"::notice::{summary}")
    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as fh:
            fh.write(f"changed=true\nsummary={summary}\n")
    # --check is a dry run for humans, so an available bump is not a failure there.
    return 0


if __name__ == "__main__":
    sys.exit(main())
