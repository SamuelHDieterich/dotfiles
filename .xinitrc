xrandr --setprovideroutputsource modesetting NVIDIA-G0
xrandr --auto
xrandr --output HDMI-1-1 --right-of eDP-1-1 --set "PRIME Synchronization" 1

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

mkdir -p "$HOME"/.local/share/keyrings

exec dbus-launch dwm
