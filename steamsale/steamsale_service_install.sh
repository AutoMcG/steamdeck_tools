#!/bin/bash

sed -e "s|WORKDIR|$( pwd )|" -e "s|SCRIPTDIR|$( pwd )/steamsale.sh|" steamsale.service_template > steamsale.service_test
systemctl --user enable "$( pwd )/steamsale.service"
systemctl --user enable "$( pwd )/steamsale.timer"

systemctl --user start steamsale.timer
