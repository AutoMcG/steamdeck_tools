#!/bin/bash

sed -e "s|WORKDIR|$( pwd )|" -e "s|SCRIPTDIR|$( pwd )/randomizer.sh|" randomvid.service_template > randomvid.service

sed -e "s|WORKDIR|$( pwd )|" -e "s|SCRIPTDIR|$( pwd )/randomizer.sh|" randomvid_graphical.service_template > randomvid_graphical.service

systemctl --user enable --now "$( pwd )/randomvid.service"

systemctl --user enable --now "$( pwd )/randomvid_graphical.service"
