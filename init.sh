#!/bin/bash
pushd modules
for f in *; do
    if [[ -d $f ]]; then
        pushd $f
            echo --- Processing module: $f
            # run pre script, if it exists and is executable
            if [[ -x pre.sh ]]; then
                echo ------ Running pre hook...
                ./pre.sh
            fi

            if [[ -d fs ]]; then
                echo ------ Linking files...

                find fs ! -path fs -printf "%P\n" | while read file; do
                    # make all directories and symlink all files
                    if [[ -d fs/$file ]]; then
                        mkdir -pv ~/$file
                    else
                        ln -srf $(pwd)/fs/$file $HOME/$file
                    fi
                done

            fi
            # run post script, if it exists and is executable
            if [[ -x post.sh ]]; then
                echo  ------ Running post hook...
                ./post.sh
            fi
            echo --- Done with module: $f
        popd
    fi
done
popd
