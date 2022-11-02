#!/bin/bash

sed -e "s|WORKDIR|$( pwd )|" -e "s|SCRIPTDIR|$( pwd )/playlist.sh|" playlist.service_template > playlist.service

systemctl --user enable --now "$( pwd )/playlist.service"
