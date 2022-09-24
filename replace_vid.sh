#!/bin/bash

#paths to vid file, css file
vid_path=/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm
css_path=/home/deck/.local/share/Steam/steamui/css/library.css

new_css_path=/home/deck/vidswap/library.css
new_vid_dir=/home/deck/vidswap/vids/
shopt -s nullglob
new_vid_files=($new_vid_dir*)
echo "files: ${new_vid_files}"

#choose desired video file
counter=1
declare -A filechoice
for i in "${new_vid_files[@]}" ; do
	filechoice[$counter]=$i
	echo "Next: $counter. $i"
	let counter=$counter+1
done

read choice
echo "$choice selected which corresponds to ${filechoice[$choice]}"
sfile=${filechoice[$choice]}
#capture pre-copy sizes
vid_size=$(stat --printf="%s" $vid_path)
css_size=$(stat --printf="%s" $css_path)
echo "Original video size: $vid_size"
echo "Original css size: $css_size"
#display propsed changes
echo "Resizing $sfile to $vid_size"
echo "Resizing $new_css_path to $css_size"
echo "Copying $sfile to $vid_path"
echo "Copying $new_css_path to $css_path"
#resize files
truncate -s $(($vid_size)) $sfile
truncate -s $(($css_size)) $new_css_path
#copy/replace files
cp $sfile $vid_path
cp $new_css_path $css_path
