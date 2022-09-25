#!/bin/bash

#init
file_to_pick=0

while getopts ":n:" option; do
    case $option in
        n) #random number
            file_to_pick=$OPTARG;;
        \?) #Invalid
            echo "Wrong usage";;
    esac
done

echo "File to pick: $file_to_pick"

RED='\033[0;31m'
NC='\033[0m'
echo "======================================="
echo -e "${RED}WARNING WARNING WARNING WARNING WARNING${NC}"
echo "======================================="
echo -e "${RED}This script replaces files and content your Steam Deck relies on during startup."
echo -e "${RED}It is provided as-is without any warranty. Use at your own risk!${NC}"
echo "With that out of the way, so far during testing if anything goes wrong,"
echo "steam automatically replaces files without any lasting negative impact."
echo ""
if ((file_to_pick==0)); then
    read -p "Do you wish to continue? (y/n)" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
fi
echo

#paths to vid file, css file
vid_path="/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm"
css_path="/home/deck/.local/share/Steam/steamui/css/library.css"

new_vid_dir="./vids/"
shopt -s nullglob
new_vid_files=($new_vid_dir*)

#choose desired video file
counter=1
declare -A file_choice

for i in "${new_vid_files[@]}" ; do
	file_choice[$counter]=$i
	echo "$counter. $i"
	let counter++
done

if ((file_to_pick==0)); then
    echo "Enter number of video file you wish to install:"
    read choice
else
    choice=$file_to_pick
fi

if [[ $choice =~ [^0-9]+ ]]; then
    echo "Entry was not a number!"
    exit 5
elif (($choice < 1 || $choice > ${#file_choice[@]})); then
    echo "Choice was not in range."
    exit 6
fi

echo "$choice selected which corresponds to ${file_choice[$choice]}"
selected_file=${file_choice[$choice]}
#capture pre-copy sizes
vid_size=$(stat --printf="%s" $vid_path)
css_size=$(stat --printf="%s" $css_path)
echo "Original video size: $vid_size"
echo "Original css size: $css_size"
#display propsed changes
echo "Resizing $selected_file to $vid_size"
echo "Changing content in $css_path and resizing to $css_size"
echo "Copying $selected_file to $vid_path"
#TODO: Add protection in case generated filepaths are empty
#copy files to tmp before modification
tmp_vid=/tmp/$(basename $selected_file)
tmp_css=/tmp/$(basename $css_path)
cp $selected_file $tmp_vid
cp $css_path $tmp_css
#make css substitusion
old_video_setting="video{flex-grow:0;width:300px;height:300px;z-index:10}"
new_video_setting="video{flex-grow:1;width:100%;height:100%;z-index:10}"
sed -i -e"s/$old_video_setting/$new_video_setting/" $tmp_css
#resize files in tmp
truncate -s $(($vid_size)) $tmp_vid
truncate -s $(($css_size)) $tmp_css
#copy files from tmp, overwrite originals
cp $tmp_vid $vid_path
cp $tmp_css $css_path
