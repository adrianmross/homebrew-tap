# Adrian Ross Homebrew Tap

Homebrew formulae for OCI operator CLIs.

## Install

```bash
brew tap adrianmross/tap
brew install oci-context bastion-session oci-hop
```

Installed binaries:

```text
/opt/homebrew/bin/oci-context
/opt/homebrew/bin/oci-contextd
/opt/homebrew/bin/bastion-session
/opt/homebrew/bin/hop
/opt/homebrew/bin/oci-hop
```

## Upgrade

```bash
brew update
brew upgrade oci-context bastion-session oci-hop
```

## Formulae

| Formula | Purpose |
| --- | --- |
| `oci-context` | OCI context, auth readiness, local metadata, and daemon support. |
| `bastion-session` | OCI Bastion managed SSH sessions and VM-facing SSH aliases. |
| `oci-hop` | Small front-door CLI for host-through-bastion workflows. |

The formulae build from tagged source releases.

## Verify

```bash
oci-context version -o json
bastion-session version -o json
hop version -o json
oci-hop version -o json
brew test adrianmross/tap/oci-context
brew test adrianmross/tap/bastion-session
brew test adrianmross/tap/oci-hop
```
