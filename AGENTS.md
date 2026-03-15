# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This is a Deno v2.0.2 TypeScript template repository (`@softdist/orchestras`) managed by **mise en place**. All tools and tasks are defined in `mise.toml`. The main entrypoint is `src/mod.ts`.

### Tool management

Tools are managed by [mise](https://mise.jdx.dev/). Run `mise install` to install Deno and any other tools. Ensure `~/.local/bin` is on `PATH`. The old `.dvmrc` has been replaced by `mise.toml`.

### Running tasks

Use `mise run <task>` or the auto-delegating `make <target>` (dashes map to colons: `make bump-patch` → `mise run bump:patch`). Run `mise tasks` for the full list.

### Key commands

```sh
mise run lint           # lint
mise run check          # type-check
mise run test           # tests (currently empty in template — "No test modules found" is expected)
mise run run            # run application
mise run build          # regenerate version.ts
mise run bump:patch     # bump version (also: bump:minor, bump:major, bump:build)
mise run tag:create     # create git tag from deno.json version
mise run tag:push       # push tags to origin
mise run git:promote    # fast-forward main to develop
```

### Version management

Version is tracked only in `deno.json` and `src/version.ts` (auto-generated). The old `.semver.*` flat files have been removed. Bump commands update the version but **do not** create or push tags — use `tag:create` then `tag:push` separately after all commits are pushed.

### Branch model

Uses a linear rebase model: `feature/* → develop → main`. Use `mise run git:promote` to fast-forward main to develop.

### Lefthook hooks

Pre-commit and pre-push hooks run via `mise run lint` and `mise run run`. Use `LEFTHOOK=0` to skip hooks when needed in this cloud environment.

### Transcrypt / .envcrypt

The Makefile no longer includes `.envcrypt`. Transcrypt is bootstrapped via `mise run secrets:init`. If `transcrypt` is not installed, the bootstrap gracefully skips.
