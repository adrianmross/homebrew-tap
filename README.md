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

Source-archive formulae — the Go tools, whose url is a single
`archive/refs/tags/vX.Y.Z.tar.gz` — are bumped automatically by
`.github/workflows/bump-formulae.yml`, which polls each upstream's latest release
every 6h and commits the new url and sha256.

It polls rather than being triggered by each release because a push-based bump needs a
credential with write access to this repo; a workflow's own `GITHUB_TOKEN` cannot write
to another repository. Polling needs no new secret. `repository_dispatch` of type
`formula-bump` is accepted too, so a source repo can trigger it immediately if such a
credential is ever added.

The cargo-dist formulae (`matrix`, `ivm`, `pump`, `secretspec`, `proxyctl`) carry several
per-platform `releases/download` urls, do not match, and are left alone.

Dry run locally:

```bash
python3 scripts/bump-formulae.py --check
```
