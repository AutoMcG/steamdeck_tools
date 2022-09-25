#!/bin/bash

new_vid_dir=./vids/
shopt -s nullglob
new_vid_files=($new_vid_dir*)
count=${#new_vid_files[@]}

random_choice=$(( 1 + $RANDOM % $count ))

echo "Selected $random_choice"
./vidswap.sh -n $random_choice
