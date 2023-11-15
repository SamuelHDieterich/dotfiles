#!/usr/bin/env bash

# ░█▀▀░█▀▀░█▀▄░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀█░▀█▀
# ░▀▀█░█░░░█▀▄░█▀▀░█▀▀░█░█░▀▀█░█▀█░█░█░░█░
# ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░▀░

# Output folder
if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

# Create folder if it doesn't exist
if [ ! -d "$XDG_PICTURES_DIR" ] ; then
    mkdir -p "$XDG_PICTURES_DIR"
fi

# Screenshot
case $1 in
  full)
    grim "$XDG_PICTURES_DIR/$(date +%s).png"
    ;;
  active)
    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$XDG_PICTURES_DIR/$(date +%s).png" 
    ;;
  area)
    slurp -c 00000000 | grim -g - "$XDG_PICTURES_DIR/$(date +%s).png"
    ;;
  *)
    echo "Usage: screenshot.sh [full|active|area]"
    exit 1
    ;;
esac

