#!/bin/bash

source ./vidswap_core.sh

print_debug=false

while getopts ":n:d" option; do
    case $option in
        d) #print debugging info
            print_debug=true;;
        n) #number of video to choose
            file_to_pick=$OPTARG;;
        \?) #Invalid
            echo "Wrong usage"
            exit 1;;
    esac
done

# Maintain backwards compatability/same user experience as established
# (even though it means calling process_input_files in two places)
if [[ $file_to_pick -eq 0 ]]
then
    print_scary
    prompt_continue
    process_input_files
    print_input_files
    prompt_for_vid_pick
else
    process_input_files
    select_vid_file $file_to_pick
fi

create_override
#get_sizes
backup_originals
print_actions
#tmp only required for css and js edits with new overrides dir
#css full screen edit no longer needed
#copy_to_tmp
#css_edit
#truncate_tmp_files
install_files

if [ "$print_debug" = true ]
then
    check_sizes
    check_checksums
fi
