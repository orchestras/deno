<!-- markdownlint-disable MD041 MD012 -->

# Deno Edge Template

**TypeScript microservice template** using [Deno](https://deno.com) +
[mise en place](https://mise.jdx.dev/) for tool and task management.

[![CI](https://img.shields.io/badge/CI-passing-green)](../../actions)
[![mise](https://img.shields.io/badge/managed%20by-mise-blue)](https://mise.jdx.dev/)

## Quick Start

```bash
curl https://mise.run | sh                         # install mise
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc && source ~/.bashrc
mise install                                       # install Deno 2.0.2 + Node 22
mise run project:init                              # fetch tags, sync version, bootstrap secrets
mise run completions                               # install shell tab-completions
```

## Tasks

Every operation is a `mise run <task>`. Run **`mise tasks`** for the full
auto-documented list. The `Makefile` is a thin alias layer (`make run` →
`mise run run`).

### Core

| Task | Description |
| --- | --- |
| `run` | Run the application |
| `check` | Type-check source |
| `lint` | Lint source |
| `fmt` / `fmt:check` | Format / check formatting |
| `test` | Run tests |
| `build` | Regenerate `src/version.ts` |
| `compile` | Cross-compile binaries to `./bin/` |

### Version & Tags

Version is derived from **git remote tags** — no `.semver.*` caches.

| Task | Description |
| --- | --- |
| `version` | Show current version |
| `version:sync` | Fetch remote tags → update deno.json + version.ts |
| `version:init` | Create v0.1.0 if no remote tags exist |
| `bump:patch` | Latest remote tag + 1 patch (e.g. 0.1.5 → 0.1.6) |
| `bump:minor` | Latest remote tag + 1 minor (e.g. 0.1.5 → 0.2.0) |
| `bump:major` | Latest remote tag + 1 major (e.g. 0.1.5 → 1.0.0) |
| `bump:build` | Latest remote tag + build metadata (e.g. 0.1.5+12345) |
| `tag:push` | Push all tags to origin |
| `tag:list` | List local tags |
| `tag:remote` | List remote tags |
| `tag:fetch` | Fetch remote tags into local |
| `tag:sync` | Sync local tags with remote (prune stale) |
| `tag:clean` | Delete all local tags **only if** remote has none |
| `tag:create` | Create tag from deno.json version |

Bump commands fetch the latest remote tag, compute the next version, update
`deno.json` + `version.ts`, and create the tag locally. Push the tag with
`mise run tag:push` after all commits are pushed.

### VCS (branching)

Linear rebase model: `feature/*` → `develop` → `main`.

| Task | Description |
| --- | --- |
| `vcs:release` | Fast-forward main to develop (rebase if needed) and push |
| `vcs:rebase` | Rebase current branch onto develop |
| `vcs:protect` | Apply branch protection ruleset to develop + main |
| `gh:token` | Show gh CLI auth status (token stays in memory) |

### Security

| Task | Description |
| --- | --- |
| `scan:ghas` | Trigger GitHub Advanced Security (CodeQL) scan |

### Secrets / NPM / Docker

| Task | Description |
| --- | --- |
| `secrets:init` | Auto-bootstrap transcrypt from repo secret |
| `npm:set-registry` | Point NPM at Artifactory |
| `npm:reset-registry` | Reset NPM to npmjs.org |
| `docker:build` | Build release Docker image |
| `docker:push` | Push image to registry |

### Setup

| Task | Description |
| --- | --- |
| `project:init` | Full init: sync tags, set version, bootstrap secrets |
| `completions` | Install shell completions (detects bash/zsh/fish, prompts) |

## Branch Model

```
feature/MCKB-2000 ──(PR rebase)──→ develop ──(vcs:release)──→ main
```

- **develop** — default branch, integration target for all PRs
- **main** — production; tags and releases originate here
- Both protected by the same ruleset (`mise run vcs:protect`)

## Artifactory Promotion

Separate from VCS promotion. Operates on build artifacts:

```
GitHub Release → Artifactory DEV → UAT → PROD
```

See workflows: `artifactory-push-binary.yml`, `artifactory-push-image.yml`,
`promote-binary.yml`, `promote-image.yml`.

## Supported Platforms

darwin (amd64, arm64) · linux (amd64, arm64) · windows (amd64)

## License

MIT — © Lynsei Asynynivynya 2025
