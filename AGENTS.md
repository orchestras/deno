# AGENTS.md

## Cursor Cloud specific instructions

### Overview

Deno 2.0.2 TypeScript template managed by **mise en place**. All tasks in
`mise.toml`. Run `mise tasks` for the full auto-documented list.

### Key commands

```sh
mise run lint             # lint
mise run check            # type-check
mise run test             # tests (template has no modules — "No test modules found" is expected)
mise run run              # run app
mise run build            # regenerate version.ts
mise run version:sync     # fetch remote tags, sync deno.json
mise run bump:patch       # bump from latest remote tag
mise run tag:push         # push tags to origin
mise run vcs:release      # fast-forward main to develop
mise run scan:ghas        # trigger CodeQL scan
```

### Version management

Version comes from git remote tags — no `.semver.*` caches. Bump tasks fetch
the latest tag from remote before computing the next version.

### Branching

Linear rebase: `feature/*` → `develop` → `main`. Use `mise run vcs:release`
to promote develop to main. Both branches share one protection ruleset.

### Lefthook

Hooks call `mise run lint` / `mise run run`. Use `LEFTHOOK=0` to skip.

### Makefile

Thin alias layer only. All logic is in `mise.toml`.
