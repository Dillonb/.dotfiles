#!/bin/bash
#
if [[ -d ~/.emacs.d ]]; then
    echo Spacemacs already installed, ignoring...
else
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
