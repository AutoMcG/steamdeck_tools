#!/bin/bash

#paths to vid file, css file
vid_path=/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm
css_path=/home/deck/.local/share/Steam/steamui/css/library.css

new_css_path=/home/deck/vidswap/library.css
new_vid_dir=/home/deck/vidswap/vids/
shopt -s nullglob
new_vid_files=($new_vid_dir*)

#choose desired video file
counter=1
declare -A file_choice
for i in "${new_vid_files[@]}" ; do
	file_choice[$counter]=$i
	echo "$counter. $i"
	let counter=$counter+1
done

read choice
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
#resize files
truncate -s $(($vid_size)) $selected_file
truncate -s $(($css_size)) $new_css_path
#copy/replace files
cp $selected_file $vid_path
cp $new_css_path $css_path
