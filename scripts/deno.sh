   #!/usr/bin/env bash
   set -u
   set -e

    if [[ $PWD == "$HOMEDIR/orchestras/deno" ]]; then
        echo "Already in the orchestras/deno directory.  Not performing refresh..."
    else

        echo "Removing the .devcontainer and scripts directories to refresh them";
        # refresh .devcontainer and scripts to latest template version
        rm -rf ./.devcontainer 
        rm -rf ./scripts 
        # copy orchestras/deno template files and clobber any existing template files
        cp -rf $HOMEDIR/orchestras/deno/scripts . 
        cp -rf $HOMEDIR/orchestras/deno/.devcontainer . 
        read -p "Overwrite Makefile? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -rf $HOMEDIR/orchestras/deno/Makefile .  || echo "Skipped Makefile." 
        read -p "Overwrite Deno.json? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && cp -rf $HOMEDIR/orchestras/deno/deno.json .  || echo "Skipped Deno.json." 
        cp -rf $HOMEDIR/orchestras/deno/.envrc . 
        cp -rf $HOMEDIR/orchestras/deno/.gitattributes . 
        cp -rf $HOMEDIR/orchestras/deno/.gitignore .
        cp -rf $HOMEDIR/orchestras/deno/.hogignore . 
        cp -rf $HOMEDIR/orchestras/deno/lefthook.yml . 
        cp -rf $HOMEDIR/orchestras/deno/LICENSE.md . 
        cp -rf $HOMEDIR/.github/copilot-instructions.md .

        deno add npm:testcontainers --dev 
        deno add npm:lefthook --dev 
        deno run -A --allow-scripts=npm:lefthook@1.11.8 npm:lefthook install
    fi

