#!/usr/bin/env bash

# This script adjusts the brightness of all monitors
# using brillo (internal display/laptop) and ddcutil (external monitors).

#############
# CONSTANTS #
#############

BRILLO_DELAY=1000000  # in microseconds
BACKUP_FILE="/tmp/brightness_backup.txt"

#############
# FUNCTIONS #
#############

# Function to display help message
help() {
    echo "Usage: $0 [set|reset|increase|decrease] [value]"
    echo "  set [value]      - Set brightness to [value] (0-100)"
    echo "  reset            - Revert brightness to previous state"
    echo "  increase [value] - Increase brightness by [value]"
    echo "  decrease [value] - Decrease brightness by [value]"
    exit 1
}

# ddcutil methods
get_current_brightness() {
    local DEV=$1
    # ddcutil command breakdown:
    # --brief: only output the values, no extra text
    # --display "$DEV": specify the display device
    # getvcp 10: get the brightness value (VCP code 10)
    ddcutil \
        --brief \
        --display "$DEV" \
        getvcp 10 \
    | grep -oP 'C \K[0-9]+'
}

set_brightness() {
    local DEV=$1
    local VALUE=$2
    # ddcutil command breakdown:
    # --display "$DEV": specify the display device
    # setvcp 10 "$VALUE": set the brightness value (VCP code 10) to VALUE
    ddcutil \
        --display "$DEV" \
        setvcp 10 "$VALUE"
}


##############
# MAIN LOGIC #
##############

# Parse command line arguments
if [ $# -lt 1 ]; then
    help
fi

ACTION=$1
VALUE=$2

# Validate arguments
case "$ACTION" in
    set|increase|decrease)
        if [ -z "$VALUE" ]; then
            echo "Error: $ACTION requires a value"
            help
        fi
        ;;
    reset)
        if [ -n "$VALUE" ]; then
            echo "Error: reset does not accept additional arguments"
            help
        fi
        ;;
    *)
        echo "Error: Invalid action '$ACTION'"
        help
        ;;
esac

# Get list of devices for ddcutil
DDC_DEVICES=$(ddcutil detect | grep 'Display' | awk '{print $2}' | xargs)

# Store current brightness levels for reset
# Only store if file doesn't exist (to avoid overwriting)
if [ ! -f "$BACKUP_FILE" ]; then
    brillo -O   # Cache current brightness for internal display
    for DEV in $DDC_DEVICES; do
        CURRENT_BRIGHTNESS=$(get_current_brightness "$DEV")
        echo "$DEV $CURRENT_BRIGHTNESS" >> "$BACKUP_FILE"
    done
fi

# Adjust brightness based on action
case "$ACTION" in
    set)
        brillo -u "$BRILLO_DELAY" -S "$VALUE" &
        for DEV in $DDC_DEVICES; do
            set_brightness "$DEV" "$VALUE" &
        done
        wait
        ;;
    increase)
        brillo -u "$BRILLO_DELAY" -A "$VALUE" &
        for DEV in $DDC_DEVICES; do
            CURRENT_BRIGHTNESS=$(get_current_brightness "$DEV")
            NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS + VALUE))
            if [ $NEW_BRIGHTNESS -gt 100 ]; then
                NEW_BRIGHTNESS=100
            fi
            set_brightness "$DEV" "$NEW_BRIGHTNESS" &
        done
        wait
        ;;
    decrease)
        brillo -u "$BRILLO_DELAY" -U "$VALUE" &
        for DEV in $DDC_DEVICES; do
            CURRENT_BRIGHTNESS=$(get_current_brightness "$DEV")
            NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS - VALUE))
            if [ $NEW_BRIGHTNESS -lt 0 ]; then
                NEW_BRIGHTNESS=0
            fi
            set_brightness "$DEV" "$NEW_BRIGHTNESS" &
        done
        wait
        ;;
    reset)
        brillo -u "$BRILLO_DELAY" -I &
        while IFS=' ' read -r DEV BRIGHTNESS; do
            set_brightness "$DEV" "$BRIGHTNESS" &
        done < "$BACKUP_FILE"
        rm "$BACKUP_FILE"
        wait
        ;;
esac
