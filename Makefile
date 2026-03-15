# Makefile — Thin wrapper that auto-delegates all targets to mise tasks.
# All tasks are defined in mise.toml. Run `mise tasks` for the full list.
#
# This Makefile auto-generates targets from `mise tasks` so you never need
# to update it manually. Just add tasks to mise.toml.
#
# Usage:
#   make help        — list all available tasks
#   make run         — delegates to `mise run run`
#   make bump-patch  — delegates to `mise run bump:patch`

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Ensure mise is on PATH
export PATH := $(HOME)/.local/bin:$(PATH)

# Convert mise task names (colon-separated) to make targets (dash-separated)
# e.g. bump:patch → bump-patch
MISE_TASKS := $(shell mise tasks --json 2>/dev/null | jq -r '.[].name' 2>/dev/null)

help: ## Show all available tasks
	@echo ""
	@echo "Available targets (delegated to mise tasks):"
	@echo "──────────────────────────────────────────────"
	@mise tasks 2>/dev/null || echo "  (mise not found — install with: curl https://mise.run | sh)"
	@echo ""
	@echo "Usage: make <target>  or  mise run <task>"
	@echo "Tip:   mise tasks --extended  for more detail"

# Auto-generate a catch-all rule that forwards any target to mise.
# Translates dashes to colons: make bump-patch → mise run bump:patch
%:
	@task_name=$$(echo "$@" | sed 's/-/:/g'); \
	if mise tasks --json 2>/dev/null | jq -e ".[] | select(.name == \"$$task_name\")" >/dev/null 2>&1; then \
		mise run "$$task_name"; \
	elif mise tasks --json 2>/dev/null | jq -e ".[] | select(.name == \"$@\")" >/dev/null 2>&1; then \
		mise run "$@"; \
	else \
		echo "Unknown task: $@ (tried: $$task_name, $@)"; \
		echo "Run 'make help' or 'mise tasks' to see available tasks."; \
		exit 1; \
	fi

.PHONY: help
