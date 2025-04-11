$(shell touch .envcrypt)
include .envcrypt
$(eval export $(shell sed -ne 's/ *#.*$$//; /./ s/=.*$$// p' .envcrypt))

# Print env var names and values
print-%: ##  Print env var names and values
	@echo $* = $($*)
echo-%: ##  Print any environment variable
	@echo $($*)
	
# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## Print all commands and help info
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

actions:  ## List Github Actions
	find . -path '*/.github/workflows/*' -type f -name '*.yml' -print0 \
		  | xargs -0 grep --no-filename "uses:" \
		  | sed 's/\- uses:/uses:/g' \
		  | tr '"' ' ' \
		  | awk '{print $2}' \
		  | sed 's/\r//g' \
		  | sort \
		  | uniq --count \
		  | sort --numeric-sort

devcontainer:  ## Make devcontainers, matrix-docker buildx bake build
	./scripts/docker_build.sh

run:  ## Run deno code
	deno run --allow-all ./src/mod.ts

check: ## Run deno check
	deno check --allow-all ./src/mod.ts

build:  ## Make local build
	deno compile --allow-all --no-check --target aarch64-apple-darwin --output ./bin/aarch64-apple-darwin/rules-engine ./src/mod.ts
	deno compile --allow-all --no-check --target x86_64-apple-darwin --output ./bin/x86_64-apple-darwin/rules-engine ./src/mod.ts
		
tag:  ## Get the latest git tag
	git describe --tags `git rev-list --tags --max-count=1`

push-tags:
	git push origin --tags

bump-major:  ## Bump the major version tag
	./scripts/bump_major.sh

bump-minor:  ## Bump the minor version tag
	./scripts/bump_minor.sh

bump-patch:  ## Bump the patch version tag
	./scripts/bump_patch.sh

bump-build:  ## Bump the build version to a random build number
	./scripts/bump_build.sh

build-release:  ## Run release build
	./scripts/build_release.sh
