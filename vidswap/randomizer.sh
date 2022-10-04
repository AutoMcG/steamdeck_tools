#!/bin/bash

source vidswap_core.sh

process_input_files
count=${#new_vid_files[@]}

random_choice=$(( 1 + $RANDOM % $count ))

echo "Selected $random_choice"
./vidswap.sh -n $random_choice
