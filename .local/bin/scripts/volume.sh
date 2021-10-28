#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    pamixer --get-volume
}

# function is_mute {
#     amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
# }

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-muted-blocking -t 8 -r 2593 -u normal "    $bar"
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	pactl set-sink-mute 0 toggle
	# Up the volume (+ 5%)
	pactl set-sink-volume 0 +3%
	send_notification
	;;
    down)
	pactl set-sink-mute 0 toggle
	pactl set-sink-volume 0 -3%
	send_notification
	;;
    mute)
    	# Toggle mute
	pactl set-sink-mute 0 toggle
	# if is_mute ; then
	#     dunstify -i audio-volume-muted -t 8 -r 2593 -u normal "Mute"
	# else
	#     send_notification
	# fi
	;;
esac