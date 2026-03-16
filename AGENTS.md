# AGENTS.md

## Cursor Cloud specific instructions

### Overview

Deno v2.0.2 TypeScript template (`@softdist/orchestras`) managed by **mise en
place**. All tools and tasks are in `mise.toml`. Main entrypoint: `src/mod.ts`.

### Tool management

Tools managed by [mise](https://mise.jdx.dev/). Run `mise install` to install
Deno 2.0.2 and Node 22. Ensure `~/.local/bin` is on `PATH`.

### Running tasks

Use `mise run <task>` or the auto-delegating `make <target>` (dashes→colons:
`make bump-patch` → `mise run bump:patch`). Run `mise tasks` for the full list.

### Key commands

```sh
mise run lint             # lint
mise run check            # type-check
mise run test             # tests (template has no test modules — "No test modules found" is expected)
mise run run              # run application
mise run build            # regenerate version.ts
mise run bump:patch       # bump version (also: bump:minor, bump:major, bump:build)
mise run tag:create       # create git tag from deno.json version
mise run tag:push         # push tags → triggers release
mise run vcs:promote      # fast-forward main to develop (VCS promotion)
mise run vcs:set-default-branch  # set develop as default branch on GitHub
mise run npm:set-registry # point npm at Artifactory
```

### Two kinds of promotion

- **VCS promotion** = moving code between branches: `feature/*` → `develop` →
  `main`
- **Artifactory promotion** = copying build artifacts between Artifactory repos:
  `dev` → `uat` → `prod`

These are completely separate concepts. VCS promotion uses
`mise run vcs:promote`. Artifactory promotion uses GitHub Actions workflow
dispatch.

### Version management

Version tracked only in `deno.json` + `src/version.ts`. Bump commands update the
version but do NOT create tags — use `tag:create` + `tag:push` separately.

### Lefthook hooks

Pre-commit/pre-push hooks use `mise run lint` and `mise run run`. Use
`LEFTHOOK=0` to skip in this cloud environment.

### Secret resolution

Conjur (if `CONJUR_API_KEY` exists) → env vars/inputs. See
`scripts/resolve_secrets.sh`.
