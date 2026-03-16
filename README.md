<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD012 -->

# Deno Edge Template

## Repository Template for TypeScript Microservices

[![CI](https://img.shields.io/badge/CI-passing-green)](../../actions)
[![mise](https://img.shields.io/badge/managed%20by-mise-blue)](https://mise.jdx.dev/)

### What is this?

A re-usable repository template for TypeScript using the **Deno** runtime,
designed for edge-compiled applications. It compiles single-purpose binary CLIs
for multiple platforms, distributable via GitHub Releases and JFrog Artifactory.

### Key Features

| Feature                   | Description                                                                  |
| ------------------------- | ---------------------------------------------------------------------------- |
| **mise en place**         | All tools (Deno, Node) and tasks managed via `mise.toml`                     |
| **Version management**    | `bump:patch`, `bump:minor`, `bump:major`, `bump:build` — tagging is separate |
| **Linear rebase model**   | `feature/*` → `develop` → `main` — rebase-only, no merge commits             |
| **Transcrypt**            | Auto-bootstrapped encrypted secrets with GH repo secret storage              |
| **Secret resolution**     | Conjur → env vars/inputs — flexible fallback chain                           |
| **Artifactory**           | Push release artifacts to dev, promote (copy) dev → uat → prod               |
| **Cross-platform builds** | Darwin, Linux, Windows (amd64/arm64)                                         |
| **LeftHook**              | Pre-commit and pre-push hooks via mise tasks                                 |

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
mise install                # install tools (Deno 2.0.2, Node 22)
mise run init               # bootstrap secrets, create initial tag, set version
mise run setup              # install shell completions (bash/zsh/fish)
```

### Common Tasks

```bash
mise tasks                  # list all tasks with descriptions
mise run run                # run the application
mise run lint               # lint source code
mise run check              # type-check
mise run test               # run tests
mise run fmt                # format source code
mise run build              # regenerate version.ts
mise run compile            # compile cross-platform binaries
mise run ci:all             # run full CI pipeline locally
```

### Makefile Compatibility

The `Makefile` is a thin auto-delegating wrapper that translates dashes to
colons:

```bash
make help                   # = mise tasks
make run                    # = mise run run
make bump-patch             # = mise run bump:patch
make vcs-promote            # = mise run vcs:promote
```

---

## Version Management

Version is tracked only in `deno.json` → auto-generated into `src/version.ts`.

### Bump Workflow

Bump commands update the version but **do not** create or push git tags. This
ensures tags only appear after all commits are pushed and CI passes.

```bash
mise run bump:patch         # 0.1.0 → 0.1.1
mise run bump:minor         # 0.1.0 → 0.2.0
mise run bump:major         # 0.1.0 → 1.0.0
mise run bump:build         # 0.1.0 → 0.1.0+12345

# After pushing all commits:
mise run tag:create         # creates git tag from deno.json version
mise run tag:push           # pushes tags to origin → triggers release workflow
```

### CI Auto-Versioning

`bump.yml` auto-bumps on push to `main` using commit message patterns (`#major`,
`#minor`, `#patch`).

---

## Branch Model — VCS Promotion

This repository uses a **two-branch linear rebase model**. VCS promotion is
about moving code between branches — it is **not** the same as Artifactory build
promotion.

```
feature/MCKB-2000 ──(PR rebase)──→ develop ──(linear rebase)──→ main
```

| Branch    | Purpose                                             | Protection                            |
| --------- | --------------------------------------------------- | ------------------------------------- |
| `develop` | **Default branch.** Integration target for all PRs. | Require PR, require CI                |
| `main`    | Production. Tags and releases originate here.       | Require PR, require CI, no force push |

### Workflow

1. Create `feature/MCKB-2000` from `develop`
2. Open a PR targeting `develop` (rebase merge)
3. When ready to release, promote develop → main:

```bash
mise run vcs:promote            # fast-forward main to develop (rebases if needed)
mise run vcs:set-default-branch # set develop as default + apply branch protection (gh CLI)
mise run vcs:rebase             # rebase current branch onto develop
```

The `vcs:set-default-branch` task uses `gh` CLI (token stays in memory, never
written to disk). It creates `develop` if missing, sets it as default, and
applies branch protection matching `main`.

---

## Artifactory — Build Promotion

Build promotion is separate from VCS promotion. It moves **artifacts** through
Artifactory environments:

```
GitHub Release → Artifactory DEV → Artifactory UAT → Artifactory PROD
```

### Push (GitHub Release → Artifactory DEV)

Manual dispatch workflows download artifacts from a GitHub Release and push them
to the Artifactory **DEV** repository:

| Workflow                      | What it pushes                                  |
| ----------------------------- | ----------------------------------------------- |
| `artifactory-push-binary.yml` | Release binaries/tarballs → `deno-binaries-dev` |
| `artifactory-push-image.yml`  | Docker image → `docker-dev-local`               |

### Promote (within Artifactory)

Promotion **copies** artifacts between Artifactory repositories. You cannot skip
environments — promotion must follow the path `dev → uat → prod`:

| Workflow             | What it does                                                    |
| -------------------- | --------------------------------------------------------------- |
| `promote-binary.yml` | Copy binaries: `deno-binaries-dev` → `uat` or `uat` → `prod`    |
| `promote-image.yml`  | Copy Docker image: `docker-dev-local` → `uat` or `uat` → `prod` |

### Secret Resolution

All Artifactory workflows resolve credentials in this order:

1. **Conjur** — if `CONJUR_API_KEY` repo secret + `CONJUR_URL`/`CONJUR_SAFE`
   vars exist
2. **Inputs** — workflow dispatch inputs (`artifactory_url`, `artifactory_user`,
   `artifactory_key`)

If both fail, the workflow errors out.

---

## NPM Registry

To point NPM at your Artifactory NPM repository:

```bash
export ARTIFACTORY_NPM_URL="https://your-instance.jfrog.io/artifactory/api/npm/npm-local/"
export ARTIFACTORY_USER="your-user"
export ARTIFACTORY_KEY="your-api-key"
mise run npm:set-registry   # configures ~/.npmrc
mise run npm:reset-registry # revert to npmjs.org
```

If Conjur is configured, credentials are resolved automatically.

---

## Secrets Management

### Transcrypt

```bash
mise run secrets:init       # auto-bootstrap or configure from repo secret
```

### Secret Resolution

```bash
source ./scripts/resolve_secrets.sh
resolve_single_secret "artifactory/url"   # auto: Conjur → env vars
resolve_single_secret "my/secret" conjur  # force Conjur
```

---

## Workflows

| Workflow                      | Trigger                 | Description                                           |
| ----------------------------- | ----------------------- | ----------------------------------------------------- |
| `ci.yml`                      | PR/push to develop/main | Lint, check, test, build, run                         |
| `bump.yml`                    | Push to main            | Auto version bump and tag                             |
| `release.yml`                 | Tag push (v*)           | Cross-platform binary build + GitHub Release          |
| `artifactory-push-binary.yml` | Manual                  | Download GH release → push to Artifactory DEV         |
| `artifactory-push-image.yml`  | Manual                  | Build + push Docker image to Artifactory DEV          |
| `promote-binary.yml`          | Manual                  | Copy binaries: dev→uat or uat→prod in Artifactory     |
| `promote-image.yml`           | Manual                  | Copy Docker image: dev→uat or uat→prod in Artifactory |

---

## Project Structure

```
├── mise.toml                   # Tool versions (Deno, Node) + all tasks
├── Makefile                    # Auto-delegating wrapper → mise tasks
├── deno.json                   # Deno config, version, dependencies
├── src/
│   ├── mod.ts                  # Main entrypoint
│   ├── version.ts              # Auto-generated version constant
│   ├── make_version.ts         # Version file generator
│   └── tests/                  # Test files
├── scripts/
│   ├── resolve_secrets.sh      # Conjur → env/input secret resolution
│   ├── transcrypt_bootstrap.sh # Auto-bootstrap transcrypt
│   ├── semver.sh               # Semver utility
│   └── colors.sh               # Terminal colors
├── .github/workflows/          # CI/CD and Artifactory workflows
├── lefthook.yml                # Git hooks → mise tasks
└── .envrc                      # direnv → mise activation
```

---

## License

MIT License. © Lynsei Asynynivynya 2025.
