#!/bin/bash

source ./vidswap_core.sh

# Get options
while getopts ":d" option; do
    case $option in
        d) #print debugging info
            print_debug=true;;
        \?) #Invalid
            echo "Wrong usage"
            exit 1;;
    esac
done

# Read files from ./vids
process_input_files
print_input_files
# Present user choice (with exit option)
prompt_for_vid_pick
# Symlink to override directory
install_vid
# Print actions
print_vid_actions
# Option: Print debugs
if [ "$print_debug" = true ]
then
    check_sizes
    check_checksums
fi
