# Adrian Ross Homebrew Tap

Homebrew formulae for OCI operator CLIs.

## Install

```bash
brew tap adrianmross/tap
brew install oci-context oci-idm secretspec bastion-session oci-hop matrix
```

`wiz` is released from a private GitHub repository. Give Homebrew a GitHub
token that can read `red-wiz/wiz-platform-cli` before installing or upgrading
it. The token is used only at formula evaluation and download time.

```bash
export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
brew install wiz
```

Installed binaries:

```text
/opt/homebrew/bin/oci-context
/opt/homebrew/bin/oci-contextd
/opt/homebrew/bin/oci-idm
/opt/homebrew/bin/oci-identity-apps
/opt/homebrew/bin/secretspec
/opt/homebrew/bin/wiz
/opt/homebrew/bin/bastion-session
/opt/homebrew/bin/hop
/opt/homebrew/bin/oci-hop
/opt/homebrew/bin/matrix
```

## Upgrade

```bash
brew update
brew upgrade oci-context oci-idm secretspec bastion-session oci-hop matrix
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" brew upgrade wiz
```

## Formulae

| Formula | Purpose |
| --- | --- |
| `oci-context` | OCI context, auth readiness, local metadata, and daemon support. |
| `oci-idm` | OCI Identity Domains applications, grants, users, and auth-target handoffs. |
| `secretspec` | Fork release of SecretSpec with composable provider workflows and Vault/OpenBao support. |
| `wiz` | Red Wiz platform CLI, installed from an authenticated private release asset. |
| `bastion-session` | OCI Bastion managed SSH sessions and VM-facing SSH aliases. |
| `oci-hop` | Small front-door CLI for host-through-bastion workflows. |
| `matrix` | Compatibility matrix CLI for zones, levels, facts, gates, and traces. |

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
oci-idm version
secretspec --version
wiz --version
bastion-session version -o json
hop version -o json
oci-hop version -o json
brew test adrianmross/tap/oci-context
brew test adrianmross/tap/oci-idm
brew test adrianmross/tap/secretspec
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" brew test adrianmross/tap/wiz
brew test adrianmross/tap/bastion-session
brew test adrianmross/tap/oci-hop
brew test adrianmross/tap/matrix
```
