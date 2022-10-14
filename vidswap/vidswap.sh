#!/bin/bash

source ./vidswap_core.sh

print_debug=false

while getopts ":d:p:" option; do
    case $option in
        d) #print debugging info
            print_debug=true;;
        p) #playlist to use
            playlist_mode=true
            playlist_input=${OPTARG};;
        \?) #Invalid
            echo "Wrong usage"
            exit 1;;
    esac
done

echo "playlist_mode: $playlist_mode"

if [[ $playlist_mode=true ]]
then
    should_prompt=false
else
    should_prompt=true
fi

if [ "$should_prompt" = true ]
then
    process_input_files
    print_input_files
    prompt_for_vid_pick
else
    if [ -f "$playlist_input" ]
    then
        read_playlist $playlist_input
    else
        create_playlist "" $playlist_input
    fi
    pop_playlist_line $playlist_input
fi

create_override
backup_originals
print_actions
install_files

if [ "$print_debug" = true ]
then
    check_sizes
    check_checksums
fi
