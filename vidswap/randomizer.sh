#!/bin/bash

source vidswap_core.sh

random_playlist_path="random_playlist.txt"

if [ ! -f $random_playlist_path ]
then
    create_playlist "" $random_playlist_path
    shuffle_playlist $random_playlist_path
fi

./vidswap.sh -p $random_playlist_path
