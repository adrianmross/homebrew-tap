# Adrian Ross Homebrew Tap

Homebrew formulae for OCI operator CLIs.

## Install

```bash
brew tap adrianmross/tap
brew install oci-context bastion-session oci-hop matrix
```

Installed binaries:

```text
/opt/homebrew/bin/oci-context
/opt/homebrew/bin/oci-contextd
/opt/homebrew/bin/bastion-session
/opt/homebrew/bin/hop
/opt/homebrew/bin/oci-hop
/opt/homebrew/bin/matrix
```

## Upgrade

```bash
brew update
brew upgrade oci-context bastion-session oci-hop matrix
```

## Formulae

| Formula | Purpose |
| --- | --- |
| `oci-context` | OCI context, auth readiness, local metadata, and daemon support. |
| `bastion-session` | OCI Bastion managed SSH sessions and VM-facing SSH aliases. |
| `oci-hop` | Small front-door CLI for host-through-bastion workflows. |
| `matrix` | Compatibility matrix CLI for zones, levels, facts, gates, and traces. |

The formulae build from tagged source releases.

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
bastion-session version -o json
hop version -o json
oci-hop version -o json
brew test adrianmross/tap/oci-context
brew test adrianmross/tap/bastion-session
brew test adrianmross/tap/oci-hop
brew test adrianmross/tap/matrix
```
