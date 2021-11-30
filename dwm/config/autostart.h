static const char *const autostart[] = {
	"picom", NULL,																	// Compositor
	"xrandr", "--output", "HDMI-1-1", "--auto", "--right-of", "eDP-1-1", NULL,		// 2 monitors
	// "mons", "-a", NULL,																// Monitors daemon
	"nitrogen", "--restore", NULL,													// Wallpaper
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", NULL,				// Polkit
	// "nm-applet", NULL,																// Network
	// "volumeicon", NULL,																// Volume
	"setxkbmap", "-model", "pc104", "-layout", "br", "-variant", "thinkpad", NULL,	// Keyboard
	"dwmblocks", NULL,																// Status bar
	NULL /* terminate */
};