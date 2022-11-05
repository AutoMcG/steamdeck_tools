#!/bin/bash

# global variables

RED='\033[0;31m'
NC='\033[0m'
OS_VERSION="20221005.1_3.3.2"

vid_override_path="/home/deck/.steam/root/config/uioverrides/movies/"
vid_path="/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm"
css_path="/home/deck/.local/share/Steam/steamui/css/library.css"
js_path="/home/deck/.local/share/Steam/steamui/library.js"

declare -A video_array
declare -A dedupe_array

vid_size=0
css_size=0
js_size=0

# Values for deubbing only as of 10/7/2022
vid_check_size=1840847
css_check_size=38631
js_check_size=289786

# Checksums as of 10/7/2022
vid_checksum="4ee82f478313cf74010fc22501b40729"
css_checksum="918832d0e497411a3e7a121838bed4e6"
js_checksum="604ef2fe25ed361688f089d8769e6c3a"

# Create vid override dir
# This be idempotent
# Reads $vid_override_path
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

# Prompt the user for a number from the vid file menu
# Exit with code if invalid choice
prompt_for_vid_pick () {
    echo ""
    echo "Enter number of video file you wish to install:"
    echo "(Enter without choice cancels)"
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
    select_vid_file "$choice"
}

prompt_for_duration () {
    echo ""
    echo "Enter duration (in seconds) you wish to allow: "
    read config_duration
    if [[ -z $config_duration ]]; then
        echo "Empty input received. Exiting..."
        exit 10
    elif [[ $config_duration =~ [^0-9]+ ]]; then
        echo "Entry was not a number!"
        exit 11
    elif (( config_duration % 10 != 0 )); then
        echo "This script only supports lengths divisible by 10."
        exit 12
    fi
    in_ms=`printf "%1.0e" $((config_duration*1000))`
    converted_duration=`echo ${in_ms/\+0/}`
    js_edit $converted_duration
}

print_vid_actions () {
    echo "Creating symlink from $filename_picked to $vid_override_path/deck_startup.webm"
}

# Populate video_array with files from arg or default
# $1 is the path to scan
process_input_files () {
    input_vid_dir=${1:-'./vids'}
    echo ""
    echo "Processing files from $input_vid_dir"
    shopt -s nullglob
    shopt -s globstar
    new_vid_files=($input_vid_dir/**/*.webm)
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

# Sets internal variables for which file to use
# $1 is the number of file to pick from menu
select_vid_file () {
    file_to_pick=$1
    filename_picked=$(realpath "${video_array[$file_to_pick]}")
    echo "$file_to_pick selected which corresponds to $filename_picked"
}

# Get and store sizes for original video, css, and js files
get_sizes () {
    vid_size=$(stat --printf="%s" $vid_path)
    css_size=$(stat --printf="%s" $css_path)
    js_size=$(stat --printf="%s" $js_path)
}

# Edits /tmp/library.css
css_edit () {
    old_video_setting="video{flex-grow:0;width:300px;height:300px;z-index:10}"
    new_video_setting="video{flex-grow:1;width:100%;height:100%;z-index:10}"
    sed -i -e"s/$old_video_setting/$new_video_setting/" $tmp_css
}

# Applies duration edit to /tmp/library.js
# $1 is duration to apply
js_edit () {
    input_duration=${1:-3e4}
    old_duration_setting="\(s,\)[1-9]e[1-9]\(,\[\]\)"
    new_duration_setting="\1$input_duration\2"
    sed -i -e"s/$old_duration_setting/$new_duration_setting/" $tmp_js
}

# Copies vid, css, and js files to tmp
# Needs: filename_picked
copy_to_tmp() {
    tmp_css="/tmp/$(basename $css_path)"
    tmp_js="/tmp/$(basename $js_path)"
    cp $css_path $tmp_css
    cp $js_path $tmp_js
}

# Truncates vid, css, and js files in tmp
truncate_tmp_files () {
    truncate -s $css_size $tmp_css
    truncate -s $js_size $tmp_js
}

# Creates video symlink from $filename_picked
install_vid () {
    ln -sf "$filename_picked" "$vid_override_path/deck_startup.webm"
    #cp $tmp_css $css_path
}

install_js () {
    cp $tmp_js $js_path
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
    echo "orig values for version $OS_VERSION"
    echo "Vid orig checksum:    $vid_checksum"
    echo "Vid current checksum: $(md5sum $vid_path | cut -f 1 -d ' ')"
    echo "Css orig checksum:    $css_checksum"
    echo "Css current checksum: $(md5sum $css_path | cut -f 1 -d ' ')"
    echo "Js orig checksum:     $js_checksum"
    echo "Js current checksum:  $(md5sum $js_path | cut -f 1 -d ' ')"
}

backup_originals () {
    mkdir -p "./backup"
    # make checksum part of the file name so we don't save duplicates
    bak_video_checksum="$(md5sum $vid_path | cut -f 1 -d ' ')"
    bak_css_checksum="$(md5sum $css_path | cut -f 1 -d ' ')"
    bak_js_checksum="$(md5sum $js_path | cut -f 1 -d ' ')"
    cp $vid_path "./backup/${bak_video_checksum}_$( basename $vid_path)"
    cp $css_path "./backup/${bak_css_checksum}_$( basename $css_path)"
    cp $js_path "./backup/${bak_js_checksum}_$( basename $js_path)"
}

restore_choice () {
    #restore css choice
    #code from https://help.gnome.org/users/zenity/stable/file-selection.html.en
    CSS_RESTORE=`zenity --file-selection --filename="$(pwd)/vidswap/backup/" --title="Select which library.css to restore"`
    case $? in
         0)
                echo "Picked CSS: $CSS_RESTORE";;
         1)
                echo "No file selected.";;
        -1)
                echo "An unexpected error has occurred."
                exit 8;;
    esac


    JS_RESTORE=`zenity --file-selection --filename="$(pwd)/vidswap/backup/" --title="Select which library.js to restore"`
    case $? in
         0)
                echo "Picked JS: $JS_RESTORE";;
         1)
                echo "No file selected.";;
        -1)
                echo "An unexpected error has occurred."
                exit 8;;
    esac
}

execute_restore () {
    cp $CSS_RESTORE $css_path
    cp $JS_RESTORE $js_path
    echo "Files restored!"
}

confirm_restore () {
    echo "Continuing with restore will copy $CSS_RESTORE to $css_path"
    echo "Continuing with restore will copy $JS_RESTORE to $js_path"
    prompt_continue
}

#Create playlist file using filenames
#$1 is directory to look in (defaults to "./vids")
#$2 is playlist to create (defaults to "./bootvid_playlist.txt")
create_playlist () {
    process_input_files $1
    playlist_path=${2:-'./bootvid_playlist.txt'}
    printf "%s\n" "${new_vid_files[@]}" > "$playlist_path"
}

#Read playlist file into $active_playlist
#$1 is filepath to playlist file (./bootvid_playlist.txt by default)
#Sets $playlist_path
read_playlist () {
    playlist_path=${1:-'./bootvid_playlist.txt'}
    readarray -t active_playlist < $playlist_path
}

#shuffle $active_playlist and rewrite playlist to $1 (./bootvid_playlist by default)
#Sets $playlist_path
#Sets $active_playlist
shuffle_playlist () {
    read_playlist $1
    active_playlist=( $( shuf -e "${active_playlist[@]}" ) )
    printf "%s\n" "${active_playlist[@]}" > "$playlist_path"
}

# https://stackoverflow.com/questions/339483/how-can-i-remove-the-first-line-of-a-text-file-using-bash-sed-script
#Sets $filename_picked
#Changes $playlist_path file
#$1 is playlist_path to pop
pop_playlist_line () {
    playlist_path=${1:-'./bootvid_playlist.txt'}
    read_playlist $playlist_path
    tail -n +2 "$playlist_path" > "$playlist_path.tmp" && mv "$playlist_path.tmp" "$playlist_path"
    playlist_choice="${active_playlist[0]}"
    echo "Choice: ${playlist_choice[0]}"
    echo "${playlist_choice[0]}" >> $playlist_path
    filename_picked=$( realpath "${playlist_choice[0]}" )
    echo "filename_picked: $filename_picked"
}

#Read files in input directory, compare to playlist, append any that don't exist
#$1 is filepath to playlist file (./bootvid_playlist.txt by default)
#Sets $playlist_path
update_playlist () {
    playlist_path=${1:-'./bootvid_playlist.txt'}
    read_playlist $playlist_path
    process_input_files
    declare -A all temp1 temp2 # associative arrays
    for element in "${new_vid_files[@]}"
    do
        ((temp1[$element]++))
        ((all[$element]++))
    done
    for element in "${active_playlist[@]}"
    do
        ((temp2[$element]++))
        ((all[$element]++))
    done
    for element in "${!all[@]}"
    do
        if (( ${temp1[$element]-0} >= 1 && ${temp2[$element]-0} >= 1 ))
        then
            unset "temp1[$element]" "temp2[$element]"
            #Left in temp1 is vid files not in playlist
            #Left in temp2 is playlist entries that don't have videos
        fi

        #Remove entry from playlist without backing vid
        if (( ${all[$element]} >= 1 && ${temp2[$element]-0} >= 1 ))
        then
            unset "all[$element]"
        fi
    done

    new_files=(${!temp1[@]} ${!temp2[@]})
    if [[ ${#new_files[@]} -gt 0 ]]
    then
        echo "Differences detected"
        printf "%s\n" "${!all[@]}" > "$playlist_path"
    fi
}
