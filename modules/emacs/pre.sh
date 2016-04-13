#!/bin/bash
#
if [[ -d ~/.emacs.d ]]; then
    echo Spacemacs already installed, updating...
    pushd ~/.emacs.d
    git pull
    popd
else
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
