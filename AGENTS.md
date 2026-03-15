# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This is a Deno v2.0.2 CLI template repository (`@softdist/orchestras`). The main entrypoint is `src/mod.ts` which prints the current version. The build system uses `make` (see `Makefile`) and Deno tasks (see `deno.json`).

### Deno path

Deno is installed at `/home/ubuntu/.deno/bin/deno`. Ensure `PATH` includes `/home/ubuntu/.deno/bin`.

### Makefile `.envcrypt` workaround

The Makefile includes `.envcrypt`, which contains encrypted data (via `transcrypt`). In this cloud environment, set `CODESPACES=true` when running `make` targets to skip the `.envcrypt` include:

```sh
CODESPACES=true make run
CODESPACES=true make check
```

Alternatively, use `deno` commands directly (no workaround needed):

```sh
deno run --allow-all ./src/mod.ts   # run
deno check src/mod.ts               # type-check
deno lint                           # lint (checks src/*.ts)
deno test -A                        # tests (currently empty in template)
deno run --allow-all src/make_version.ts  # regenerate src/version.ts from deno.json
```

### `deno install` note

Running `deno install` may fail with an `Unknown export './unstable-snapshot'` error from a transitive dependency. This does not affect core lint/check/run functionality. The main source files cache fine via `deno cache --reload src/mod.ts`. For the update script, `deno install` errors can be ignored since the essential deps resolve at runtime.

### Tests

The `deno.json` test config has `"include": []`, so `deno test` reports "No test modules found." This is by design in the template.

### Key commands reference

See `Makefile` (`make help` for full list) and `deno.json` `"tasks"` section for all available commands.
