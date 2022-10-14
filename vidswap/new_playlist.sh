#!/bin/bash

source ./vidswap_core.sh

# Get options
while getopts ":d:p" option; do
    case $option in
        p) #playlist to use
            playlist_input=${OPTARG};;
        \?) #Invalid
            echo "Wrong usage"
            exit 1;;
    esac
done

playlist_input="${1:-./bootvid_playlist.txt}"

if [ -f "$playlist_input" ]
then
    read_playlist $playlist_input
else
    create_playlist "" $playlist_input
fi

pop_playlist_line $playlist_input
install_vid
