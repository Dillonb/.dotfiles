#!/usr/bin/env bash
set -e
CONFIG_LOCATION=./local/config/modules

# Ensure submodules are available
git submodule update --init

if [[ -f ./local/config/modules ]]; then
    source $CONFIG_LOCATION
else
    echo '#!/bin/bash
MODULES=()' > $CONFIG_LOCATION
    echo "Please configure modules in $CONFIG_LOCATION"
fi

# Silent pushd and popd
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

# Module
pushd modules
for f in "${MODULES[@]}"; do
    if [[ -d $f ]]; then
        pushd $f
            echo Installing module: $f
            # run pre script, if it exists and is executable
            if [[ -x pre.sh ]]; then
                ./pre.sh
            fi

            if [[ -d fs ]]; then
                find fs ! -path fs -printf "%P\n" | while read file; do
                    # make all directories and symlink all files
                    if [[ -d fs/$file ]]; then
                        mkdir -p ~/$file
                    else
                        ln -sfv $(pwd)/fs/$file $HOME/$file
                    fi
                done

            fi
            # run post script, if it exists and is executable
            if [[ -x post.sh ]]; then
                ./post.sh
            fi
        popd
    else
        echo "WARNING: module $f specified, but directory not found."
    fi
done
popd

echo Done! Rerun this script to update after pulling, and periodically to update some installed components.
