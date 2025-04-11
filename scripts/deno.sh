   #!/usr/bin/env bash
   set -u
   set -e

    if [[ $PWD == "$HOMEDIR/orchestras/deno" ]]; then
        echo "Already in the orchestras/deno directory.  Not performing refresh..."
    else

        echo "Removing the .devcontainer and scripts directories to refresh them";
        # remove .devcontainer and scripts to refresh sync to latest version
        rm -rf ./.devcontainer 
        rm -rf ./scripts 
        # copy orchestras/deno template files and clobber any existing template files
        cp -rf $HOMEDIR/orchestras/deno/scripts . 
        cp -rf $HOMEDIR/orchestras/deno/.devcontainer . 
        read -p "Overwrite Makefile? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -f $HOMEDIR/orchestras/deno/Makefile .  || echo "Skipped Makefile." 
        read -p "Overwrite Deno.json? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -f $HOMEDIR/orchestras/deno/deno.json .  || echo "Skipped Deno.json." 
        cp -f $HOMEDIR/orchestras/deno/.envrc . 
        cp -f $HOMEDIR/orchestras/deno/.gitattributes . 
        cp -f $HOMEDIR/orchestras/deno/.gitignore .
        cp -f $HOMEDIR/orchestras/deno/.hogignore . 
        cp -f $HOMEDIR/orchestras/deno/lefthook.yml . 
        cp -f $HOMEDIR/orchestras/deno/LICENSE.md . 

        mkdir -p ./.github/workflows ./.github/actions
        cp -f $HOMEDIR/.github/copilot-instructions.md .
        cp -f $HOMEDIR/.github/CODEOWNERS .
        cp -f $HOMEDIR/.github/workflows/bump.yml .
        deno outdated --update --latest
        deno add npm:testcontainers --dev 
        deno add npm:lefthook --dev 
        deno run -A --allow-scripts=npm:lefthook@1.11.8 npm:lefthook install
    fi

