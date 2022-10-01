#!/bin/bash

systemctl --user disable --now steamsale.service
systemctl --user disable --now steamsale.timer
