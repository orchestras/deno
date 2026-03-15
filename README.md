<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD012 -->

# Deno Edge Template

## Repository Template for TypeScript Microservices

[![CI](https://img.shields.io/badge/CI-passing-green)](../../actions)
[![mise](https://img.shields.io/badge/managed%20by-mise-blue)](https://mise.jdx.dev/)

### What is this?

A re-usable repository template for TypeScript using the **Deno** runtime, designed
for edge-compiled applications. It compiles single-purpose binary CLIs for multiple
platforms, distributable via GitHub Releases and Artifactory.

### Key Features

| Feature | Description |
|---|---|
| **mise en place** | All tools and tasks managed via `mise.toml` — no global installs needed |
| **Version management** | `bump:build`, `bump:patch`, `bump:minor`, `bump:major` — tag pushed separately |
| **Linear rebase model** | `develop` → `main` promotion with rebase-only merges |
| **Transcrypt** | Auto-bootstrapped encrypted secrets with GH repo secret storage |
| **Secret resolution** | Conjur → Azure Key Vault → env vars/inputs — flexible fallback chain |
| **Artifactory** | Push and promote binaries and Docker images (dev → uat → prod) |
| **Cross-platform builds** | Darwin, Linux, Windows (amd64/arm64) |
| **LeftHook** | Pre-commit and pre-push hooks using mise tasks |

### Supported Platforms

- **darwin**: amd64, arm64
- **linux**: amd64, arm64
- **windows**: amd64

---

## Quick Start

### Prerequisites

Install [mise](https://mise.jdx.dev/getting-started.html):

```bash
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

### Setup

```bash
# Install tools (Deno) and initialise the project
mise install
mise run init

# Optional: install shell completions
mise run setup
```

### Common Tasks

```bash
mise tasks              # list all tasks with descriptions
mise run run            # run the application
mise run lint           # lint source code
mise run check          # type-check
mise run test           # run tests
mise run build          # regenerate version.ts
mise run compile        # compile cross-platform binaries
```

### Makefile Compatibility

The `Makefile` is a thin auto-delegating wrapper. All targets forward to mise:

```bash
make help               # same as `mise tasks`
make run                # same as `mise run run`
make bump-patch         # same as `mise run bump:patch`
```

---

## Version Management

Version is tracked in `deno.json` and auto-generated into `src/version.ts`.
The old `.semver.*` flat-file caching has been removed.

### Bump Workflow

Bump commands update `deno.json` and regenerate `version.ts`, but **do not**
create or push git tags. This separates version bumping from tag pushing so
tags are only pushed after all commits are ready.

```bash
mise run bump:patch     # 0.1.0 → 0.1.1
mise run bump:minor     # 0.1.0 → 0.2.0
mise run bump:major     # 0.1.0 → 1.0.0
mise run bump:build     # 0.1.0 → 0.1.0+12345

# After committing and pushing all changes:
mise run tag:create     # creates git tag from deno.json version
mise run tag:push       # pushes tags to origin (triggers release)
```

### CI Auto-Versioning

The `bump.yml` workflow auto-bumps on push to `main` using commit message
patterns (`#major`, `#minor`, `#patch`).

---

## Branch Model (Linear Rebase)

This repository uses a **two-branch linear rebase model**:

```
feature/* ──→ develop ──→ main
```

| Branch | Purpose | Protection |
|---|---|---|
| `main` | Production-ready code. Tags and releases come from here. | Require PR, require CI, no force push |
| `develop` | Integration branch. All feature PRs target develop. | Require PR, require CI, no force push |

### Workflow

1. Create a feature branch from `develop`
2. Open a PR targeting `develop`
3. After CI passes, merge (squash or rebase)
4. When ready to release, promote develop → main:

```bash
mise run git:promote    # fast-forward main to develop (rebases if needed)
```

### Rebase current branch onto develop

```bash
mise run git:rebase
```

---

## Secrets Management

### Transcrypt (Encrypted Files)

Transcrypt encrypts files listed in `.gitattributes` (e.g. `.envcrypt`).
The bootstrap process is fully automatic:

```bash
mise run secrets:init
```

- If a `TRANSCRYPT_PASSWORD` repo secret exists → configures transcrypt from it
- If no secret exists → generates a new password, bootstraps, and stores it as a repo secret
- If an encrypted file exists without a matching secret → cleans up stale file

### Secret Resolution Chain

All Artifactory and deployment workflows use a unified resolution chain:

1. **Conjur** — if `CONJUR_API_KEY` (secret) + `CONJUR_URL`, `CONJUR_SAFE` (vars) exist
2. **Azure Key Vault** — if `AZURE_KEY_VAULT_NAME` (var) exists
3. **Inputs / env vars** — manual fallback

Each workflow has a `secret_provider` input to override the auto-detection.

---

## Workflows

| Workflow | Trigger | Description |
|---|---|---|
| `ci.yml` | PR to develop/main, push to develop | Lint, check, test, build, run |
| `bump.yml` | Push to main | Auto version bump and tag |
| `release.yml` | Tag push (v*) | Cross-platform binary build + GitHub Release |
| `artifactory-push-binary.yml` | Manual dispatch | Push binary artifacts to Artifactory |
| `artifactory-push-image.yml` | Manual dispatch | Build and push Docker image to Artifactory |
| `promote-binary.yml` | Manual dispatch | Copy binary: dev → uat or uat → prod |
| `promote-image.yml` | Manual dispatch | Copy Docker image: dev → uat or uat → prod |

### Promotion Rules

- Artifacts always flow `dev → uat → prod` (copy, not move)
- Direct `dev → prod` promotion is **not allowed**
- Promotion uses the same secret resolution chain

---

## Project Structure

```
├── mise.toml               # Tool versions + all tasks
├── Makefile                # Auto-delegating wrapper (optional)
├── deno.json               # Deno config, version, dependencies
├── src/
│   ├── mod.ts              # Main entrypoint
│   ├── version.ts          # Auto-generated version constant
│   ├── make_version.ts     # Version file generator
│   └── tests/              # Test files
├── scripts/
│   ├── resolve_secrets.sh  # Conjur/Azure/input secret resolution
│   ├── transcrypt_bootstrap.sh  # Auto-bootstrap transcrypt
│   ├── semver.sh           # Semver utility
│   └── colors.sh           # Terminal colors
├── .github/workflows/      # CI/CD workflows
├── lefthook.yml            # Git hooks (uses mise tasks)
└── .envrc                  # direnv → mise activation
```

---

## License

MIT License. © Lynsei Asynynivynya 2025.
