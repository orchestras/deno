#!/usr/bin/env bash

# template:
export HOMEDIR=$HOME/Documents/gh/orchestras/deno

# refresh from template:
if [[ -d "$HOMEDIR" ]]; then
    read -p "Refresh Template? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && . scripts/deno.sh  || echo "Skipped Refresh." 
else
  # ignore template refreshing itself
  echo "Template $HOMEDIR does not exist. Please clone the template repository into the folder in your homedir ($HOMEDIR) specified in '.envrc'."
  exit 1
fi

echo "Validating Deno Installation..."
. ./scripts/setup_deno.sh

echo "Creating version from git tag and installing it to deno.json & version.ts ..."
make set-version

echo "Installing Dependencies..."
deno outdated --update --latest
deno task dev-install
lefthook install

echo "Pulling Docker Images..."
make client

echo ""
echo "Run DevContainer:  'docker-compose run devcontainer -f .devcontainer/docker-compose.yml'"
echo "Build DevContainer:  'make devcontainer'"
echo ""
echo "[ Makefile Info ]  (type: 'make help' for more information)"
