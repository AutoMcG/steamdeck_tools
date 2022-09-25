#!/bin/bash

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
read -p "Do you wish to continue? (y/n)" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Exiting..."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
#paths to vid file, css file
vid_path=/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm
css_path=/home/deck/.local/share/Steam/steamui/css/library.css

new_css_path=./library.css
new_vid_dir=./vids/
shopt -s nullglob
new_vid_files=($new_vid_dir*)

#choose desired video file
counter=1
declare -A file_choice
echo "Enter number of video file you wish to install:"
for i in "${new_vid_files[@]}" ; do
	file_choice[$counter]=$i
	echo "$counter. $i"
	let counter++
done

read choice
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
echo "Resizing $new_css_path to $css_size"
echo "Copying $selected_file to $vid_path"
echo "Copying $new_css_path to $css_path"
#copy files to tmp, resize
tmp_vid=/tmp/$(basename $selected_file)
tmp_css=/tmp/$(basename $new_css_path)
cp $selected_file /tmp/$(basename $selected_file)
cp $new_css_path /tmp/$(basename $new_css_path)
truncate -s $(($vid_size)) $tmp_vid
truncate -s $(($css_size)) $tmp_css
#copy/replace files
cp $tmp_vid $vid_path
cp $tmp_css $css_path
