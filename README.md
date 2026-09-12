# adrianmross's brew tap

## Install

```bash
brew tap adrianmross/tap
brew install oci-context
```

## Upgrade

```bash
brew update
brew upgrade oci-context
```

## Formulae

| Formula | Purpose |
| --- | --- |
| `bastion-session` | OCI Bastion managed SSH sessions and VM-facing SSH aliases. |
| `ivm` | Istio version manager, manage versions and apply saved profiles to clusters. |
| `matrix` | Compatibility matrix CLI for zones, levels, facts, gates, and traces. |
| `oci-context` | OCI context, auth readiness, local metadata, and daemon support. |
| `oci-idm` | OCI Identity Domains applications, grants, users, and auth-target handoffs. |
| `oci-hop` | Small front-door CLI for host-through-bastion workflows. |
| `secretspec` | Fork release of SecretSpec with composable provider workflows and Vault/OpenBao support. |

Most formulae build from tagged source releases. The `matrix` formula installs
prebuilt release archives for macOS and Linux so users do not need a local Rust
build for normal installs. The archive includes `matrix`, `matrix-enter`, and
`matrix-construct`.

## Development

This repo uses `devenv` and `direnv`:

```bash
direnv allow
devenv test
```

Useful tasks:

```bash
devenv tasks run tap:syntax
devenv tasks run tap:audit
devenv tasks run tap:brew-test
devenv tasks run tap:validate
```

`tap:syntax` runs anywhere the dev shell works. `tap:audit` and
`tap:brew-test` require Homebrew, so they are expected to run on a Homebrew
host such as macOS or Linuxbrew.

## Verify

```bash
oci-context version -o json
brew test adrianmross/tap/oci-context
```

## Formula bumps

Formulae are bumped automatically by `.github/workflows/bump-formulae.yml`, which polls each
upstream's latest release every 6h and commits the new urls and sha256s.

Both shapes in this tap are handled, because the rewrite is the same operation either way --
find every GitHub url, swap the version, recompute the checksum that follows it:

- **source archive** (the Go tools): one `archive/refs/tags/vX.Y.Z.tar.gz` url
- **release binaries** (the cargo-dist tools): one `releases/download/vX.Y.Z/<asset>` url per
  platform

A formula is only touched when every url in it agrees on owner/repo/version; a mixed one is
skipped rather than guessed at. Checksums always come from a real download of the exact asset
the formula will point at, never from API metadata, and a retargeted url is checked for
existence before it is hashed -- some cargo-dist assets embed the version in the filename
(`matrix-0.3.33-aarch64-apple-darwin.tar.gz`) and some do not (`pump-aarch64-apple-darwin.tar.xz`),
so swapping only the path segment would silently 404 for the former.

It polls rather than being triggered by each release because a push-based bump needs a
credential with write access to this repo; a workflow's own `GITHUB_TOKEN` cannot write to
another repository. `repository_dispatch` of type `formula-bump` is accepted, so a source repo
holding such a credential can trigger it immediately.

Dry run locally:

```bash
python3 scripts/bump-formulae.py --check
python3 scripts/bump-formulae.py --only matrix   # limit to one formula
```
