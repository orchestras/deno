# import config

ifeq ($(shell test -e .env),yes)
	cnf ?= .env
	include $(cnf)
	export $(shell sed 's/=.*//' $(cnf))
endif

# HIDDEN
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

envs:  ## Source env file if you are running local
	./env.sh

downstream-tags:  ## Downstream:  List git tags
	git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' https://github.com/softdist/docker.client.git

git-head:  ## Get the latest git tag
	git tag -l | tail -n 1

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
