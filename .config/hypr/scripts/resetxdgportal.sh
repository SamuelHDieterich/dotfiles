#!/usr/bin/env bash

# ░█▀▄░█▀▀░█▀▀░█▀▀░▀█▀░░░█░█░█▀▄░█▀▀░░░█▀█░█▀█░█▀▄░▀█▀░█▀█░█░░
# ░█▀▄░█▀▀░▀▀█░█▀▀░░█░░░░▄▀▄░█░█░█░█░░░█▀▀░█░█░█▀▄░░█░░█▀█░█░░
# ░▀░▀░▀▀▀░▀▀▀░▀▀▀░░▀░░░░▀░▀░▀▀░░▀▀▀░░░▀░░░▀▀▀░▀░▀░░▀░░▀░▀░▀▀▀

# This script is used to reset the xdg-desktop-portal-hyprland and xdg-desktop-portal

sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
