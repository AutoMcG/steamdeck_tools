#!/bin/bash

# global variables

RED='\033[0;31m'
NC='\033[0m'

vid_override_path="/home/deck/.steam/root/config/uioverrides/movies/"
vid_path="/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm"
css_path="/home/deck/.local/share/Steam/steamui/css/library.css"
js_path="/home/deck/.local/share/Steam/steamui/library.js"

declare -A video_array

file_to_pick=0
filename_picked=""

vid_size=0
css_size=0
js_size=0

# Values for deubbing only as of 10/3/2022
vid_check_size=1840847
css_check_size=38631
js_check_size=289786

# Checksums as of 10/3/2022
vid_checksum="4ee82f478313cf74010fc22501b40729"
css_checksum="b3565c92eacbc7d2afe3cc070550d0a4"
js_checksum="604ef2fe25ed361688f089d8769e6c3a"

# Create vid override dir
# This be idempotent
create_override () {
    mkdir -p $vid_override_path
}

# Display scaring warning
print_scary () {
    echo "======================================="
    echo -e "${RED}WARNING WARNING WARNING WARNING WARNING${NC}"
    echo "======================================="
    echo -e "${RED}This script replaces files and content your Steam Deck relies on during startup."
    echo -e "${RED}It is provided as-is without any warranty. Use at your own risk!${NC}"
    echo "With that out of the way, so far during testing if anything goes wrong,"
    echo "steam automatically replaces files without any lasting negative impact."
    echo ""
}

# Safety check with user
prompt_continue () {
    read -p "Do you wish to continue? (y/n)" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Exiting..."
        exit 1
    fi
    echo ""
}

print_actions () {
    echo "Creating symlink from $filename_picked to $vid_override_path/deck_startup.webm"
    #echo "Changing content in $css_path and resizing to $css_size"
    #echo "Files will be copied to /tmp/ and modified there"
}

# Populate video_array with files from arg or default
# $1 is the path to scan - must end in /
process_input_files () {
    input_vid_dir=${1:-'./vids/'}
    echo "Processing files from $input_vid_dir"
    shopt -s nullglob
    new_vid_files=($input_vid_dir*)
    counter=1
    for i in "${new_vid_files[@]}" ; do
        video_array[$counter]=$i
        let counter++
    done
}

# Print list and index of all files available in source
print_input_files () {
    counter=1
    for i in "${new_vid_files[@]}" ; do
        echo "$counter. $i"
        let counter++
    done
}

# Prompt the user for a number from the vid file menu
# Exit with code if invalid choice
prompt_for_vid_pick () {
    echo ""
    echo "Enter number of video file you wish to install:"
    read choice
    if [[ -z $choice ]]; then
        echo "Empty input received. Exiting..."
        exit 5
    elif [[ $choice =~ [^0-9]+ ]]; then
        echo "Entry was not a number!"
        exit 6
    elif (($choice < 1 || $choice > ${#video_array[@]})); then
        echo "Choice was not in range."
        exit 7
    fi
    select_vid_file $choice
}

# Sets internal variables for which file to use
# $1 is the number of file to pick from menu
select_vid_file () {
    file_to_pick=$1
    filename_picked="$(realpath ${video_array[$file_to_pick]})"
    echo "$file_to_pick selected which corresponds to $filename_picked"
}

# Get and store sizes for original video, css, and js files
get_sizes () {
    #vid_size=$(stat --printf="%s" $vid_path)
    css_size=$(stat --printf="%s" $css_path)
    js_size=$(stat --printf="%s" $js_path)
}

# Edits /tmp/library.css
css_edit () {
    old_video_setting="video{flex-grow:0;width:300px;height:300px;z-index:10}"
    new_video_setting="video{flex-grow:1;width:100%;height:100%;z-index:10}"
    sed -i -e"s/$old_video_setting/$new_video_setting/" $tmp_css
}

# Copies vid, css, and js files to tmp
# Needs: filename_picked
copy_to_tmp() {
    #tmp_vid="/tmp/$(basename $filename_picked)"
    tmp_css="/tmp/$(basename $css_path)"
    tmp_js="/tmp/$(basename $js_path)"
    #cp $filename_picked $tmp_vid
    cp $css_path $tmp_css
    cp $js_path $tmp_js
}

# Truncates vid, css, and js files in tmp
truncate_tmp_files () {
    #truncate -s $vid_size $tmp_vid
    truncate -s $css_size $tmp_css
    truncate -s $js_size $tmp_js
}

# Creates video symlink
install_files () {
    #cp $tmp_vid $vid_path
    ln -sf $filename_picked "$vid_override_path/deck_startup.webm"
    #cp $tmp_css $css_path
    #cp $tmp_js $js_path
}

# Useful for debugging
check_sizes () {
    get_sizes
    echo "Vid orig size:    $vid_check_size"
    echo "Vid current size: $vid_size"
    echo "Css orig size:    $css_check_size"
    echo "Css current size: $css_size"
    echo "Js orig size:     $js_check_size"
    echo "Js current size:  $js_size"
}

# Useful for debugging
check_checksums () {
    echo "Vid orig checksum:    $vid_checksum"
    echo "Vid current checksum: $(md5sum $vid_path | cut -f 1 -d ' ')"
    echo "Css orig checksum:    $css_checksum"
    echo "Css current checksum: $(md5sum $css_path | cut -f 1 -d ' ')"
    echo "Js orig checksum:     $js_checksum"
    echo "Js current checksum:  $(md5sum $js_path | cut -f 1 -d ' ')"
}
