#!/bin/bash

source ./vidswap_core.sh

playlist="${1-'./random_playlist.txt'}"
echo "from top script: $playlist"
shuffle_playlist $playlist
