#!/bin/bash

CONFIG_LOCATION=~/.dotfiles/local/config/wallpaper

if [ -s $CONFIG_LOCATION ];
then

    feh --bg-scale `cat $CONFIG_LOCATION`
else
    touch $CONFIG_LOCATION
    echo "Please set your wallpaper in $CONFIG_LOCATION"
fi

