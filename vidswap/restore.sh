#!/bin/bash

source ./vidswap_core.sh

restore_choice
confirm_restore
backup_originals
execute_restore
check_checksums
check_sizes
