#!/usr/bin/env bash

# Check if Nix is installed
if ! command -v nix-env &> /dev/null; then
    echo "Nix is not installed. Please install Nix before running this script."
    exit 1
fi

# Check if Home Manager is already installed
if command -v home-manager &> /dev/null; then
    echo "Home Manager is already installed."
    exit 1
fi

# Choose the release channel to use
while true; do
    read -p "Which release channel would you like to use? " channel
    case $channel in
        unstable)
            branch=master
            break;;
        *)
            branch=release-${channel}
            break;;
    esac
done

nix \
    --extra-experimental-features nix-command \
    nix-channel \
    --add https://github.com/nix-community/home-manager/archive/${branch}.tar.gz \
    home-manager
nix-channel --update
nix run home-manager/${branch} -- init --switch