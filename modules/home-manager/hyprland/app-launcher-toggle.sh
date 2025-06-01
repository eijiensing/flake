#!/usr/bin/env bash

# Check if the launcher instance is running
if ags list | grep -q 'launcher'; then
  # Toggle it if it is running
  ags toggle launcher -i launcher
else
  # Start it if it isn't running
  ags run ~/.config/ags/launcher.ts &
fi
