#!/bin/bash

# Silent pushd and popd
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

# Module
pushd modules
for f in *; do
    if [[ -d $f ]]; then
        pushd $f
            echo $f
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
                        ln -sf $(pwd)/fs/$file $HOME/$file
                    fi
                done

            fi
            # run post script, if it exists and is executable
            if [[ -x post.sh ]]; then
                ./post.sh
            fi
        popd
    fi
done
popd

echo Done! Rerun this script to update after pulling, and periodically to update some installed components.
