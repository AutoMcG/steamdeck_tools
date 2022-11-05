#!/bin/bash

source ./vidswap_core.sh

restore_choice
confirm_restore
if [ $? -eq 0 ]
then
    backup_originals
    execute_restore
else
    echo "User cancelled. Exiting..."
    exit 1
fi

check_checksums
check_sizes
