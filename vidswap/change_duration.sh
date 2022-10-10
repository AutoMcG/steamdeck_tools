#!/bin/bash

source ./vidswap_core.sh

print_debug=false

while getopts ":d" option; do
    case $option in
        d) #print debugging info
            print_debug=true;;
        \?) #Invalid
            echo "Wrong usage"
            exit 1;;
    esac
done

print_scary
prompt_continue
backup_originals
get_sizes
copy_to_tmp
prompt_for_duration
truncate_tmp_files
install_js

if [ "$print_debug" = true ]
then
    check_sizes
    check_checksums
fi
