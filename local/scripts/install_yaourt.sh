#!/bin/bash
pushd /tmp
mkdir install_yaourt
pushd install_yaourt
git clone https://aur.archlinux.org/package-query.git
pushd package-query
makepkg -si
popd
git clone https://aur.archlinux.org/yaourt.git
pushd yaourt
makepkg -si
popd
popd
popd
