# Adrian Ross Homebrew Tap

Homebrew formulae for OCI operator CLIs.

## Install

```bash
brew tap adrianmross/tap
brew install oci-context bastion-session oci-bassh
```

Installed binaries:

```text
/opt/homebrew/bin/oci-context
/opt/homebrew/bin/oci-contextd
/opt/homebrew/bin/bastion-session
/opt/homebrew/bin/oci-bassh
```

## Upgrade

```bash
brew update
brew upgrade oci-context bastion-session oci-bassh
```

## Formulae

| Formula | Purpose |
| --- | --- |
| `oci-context` | OCI context, auth readiness, local metadata, and daemon support. |
| `bastion-session` | OCI Bastion managed SSH sessions and VM-facing SSH aliases. |
| `oci-bassh` | Small front-door CLI for host-through-bastion workflows. |

The formulae build from tagged source releases.

## Verify

```bash
oci-context version -o json
bastion-session version -o json
oci-bassh version -o json
brew test adrianmross/tap/oci-context
brew test adrianmross/tap/bastion-session
brew test adrianmross/tap/oci-bassh
```
