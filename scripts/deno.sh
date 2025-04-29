   #!/usr/bin/env bash
    if [[ $PWD == "$HOMEDIR" ]]; then
        echo "Already in the $HOMEDIR directory.  Not performing refresh..."
    else

        echo "Removing the .devcontainer and scripts directories to refresh them";
        # remove .devcontainer and scripts to refresh sync to latest version
        rm -rf ./.devcontainer
        rm -rf ./scripts
        # copy template files and clobber any existing template files
        cp -rf $HOMEDIR/scripts .
        cp -rf $HOMEDIR/.devcontainer .
        read -p "Overwrite Makefile? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -f $HOMEDIR/Makefile .  || echo "Skipped Makefile."
        read -p "Overwrite Deno.json? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -f $HOMEDIR/deno.json .  || echo "Skipped Deno.json."
        cp -f $HOMEDIR/.envrc .
        touch $HOMEDIR/.envcrypt
        cp -f $HOMEDIR/.gitattributes .
        cp -f $HOMEDIR/.gitignore .
        cp -f $HOMEDIR/.hogignore .
        cp -f $HOMEDIR/.prettierrc .
        cp -f $HOMEDIR/.editorconfig .
        cp -f $HOMEDIR/.prettierignore .
        cp -f $HOMEDIR/connect.yml .
        cp -f $HOMEDIR/.semver.author.gpg.tag .
        touch $HOMEDIR/.semver.build.tag
        git log | head -n 2 > $HOMEDIR/.semver.commit.tag
        touch $HOMEDIR/.semver.version.tag
        cp -f $HOMEDIR/lefthook.yml .
        cp -f $HOMEDIR/LICENSE .
        cp -f $HOMEDIR/CONTRIBUTING.md .
        mkdir -p ./.github/workflows ./.github/actions
        cp -f $HOMEDIR/.github/copilot-instructions.md ./.github/
        cp -f $HOMEDIR/.github/CODEOWNERS ./.github/
        cp -f $HOMEDIR/.github/workflows/bump.yml ./.github/

        deno outdated --update --latest
        deno add npm:testcontainers --dev
        deno add npm:lefthook --dev
        deno run -A --allow-scripts=npm:lefthook@1.11.8 npm:lefthook install
    fi

