#!/bin/bash

source vidswap_core.sh

process_input_files
count=${#new_vid_files[@]}

declare -A random_count

for ((i=1; i<=$count; i++))
do
    #set up associate array with initial value of 0 for each seleciton
    random_count[$i]=0
done

#number of times to run randomization
random_iterations=100000

for ((j=1;j<=random_iterations;j++))
do
    random_choice=$(( 1 + $RANDOM % $count ))
    ((random_count[$random_choice]++))
done

for i in "${!random_count[@]}"
do
  echo "random_selection/count: $i | ${random_count[$i]}"
done

#./vidswap.sh -n $random_choice
