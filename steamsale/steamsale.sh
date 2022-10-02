#!/bin/bash

#paths to vid file, css file
vid_path="/home/deck/.local/share/Steam/steamui/movies/deck_startup.webm"
css_path="/home/deck/.local/share/Steam/steamui/css/library.css"
js_path="/home/deck/.local/share/Steam/steamui/library.js"

new_vid_path="./UncleGrim_TonightsTheNight.webm"

#capture pre-copy sizes
vid_size=$(stat --printf="%s" $vid_path)
css_size=$(stat --printf="%s" $css_path)
js_size=$(stat --printf="%s" $js_path)

echo "Original video size: $vid_size"
echo "Original css size: $css_size"
echo "Original js size: $js_size"

#display propsed changes
echo "Resizing $new_vid_path to $vid_size and copying to $vid_path"
echo "Changing content in $css_path and resizing to $css_size"
echo "Changing content in $js_path and resizing to $js_size"
echo "Files will be copied to /tmp/ and modified there"

#copy files to tmp before modification
tmp_vid=/tmp/$(basename $new_vid_path)
tmp_css=/tmp/$(basename $css_path)
tmp_js=/tmp/$(basename $js_path)
cp $new_vid_path $tmp_vid
cp $css_path $tmp_css
cp $js_path $tmp_js

#make css substitusions
old_video_setting="video{flex-grow:0;width:300px;height:300px;z-index:10}"
new_video_setting="video{flex-grow:1;width:100%;height:100%;z-index:10}"
sed -i -e"s/$old_video_setting/$new_video_setting/" $tmp_css

old_duration="i,1e4"
new_duration="i,4e4"
sed -i -e"s/$old_duration/$new_duration/" $tmp_js

#resize files in tmp
truncate -s $(($vid_size)) $tmp_vid
truncate -s $(($css_size)) $tmp_css
truncate -s $(($js_size)) $tmp_js

#copy files from tmp, overwrite originals
cp $tmp_vid $vid_path
cp $tmp_css $css_path
cp $tmp_js $js_path
