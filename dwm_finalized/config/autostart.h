static const char *const autostart[] = {
	"picom", NULL,																	// Compositor
	"xrandr", "--output", "HDMI-1-1", "--auto", "--right-of", "eDP-1-1", NULL,		// 2 monitors
	"nitrogen", "--restore", NULL,													// Wallpaper
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", NULL,				// Polkit
	"setxkbmap", "-model", "pc104", "-layout", "br", "-variant", "thinkpad", NULL,	// Keyboard
	"dwmblocks", NULL,																// Status bar
	NULL /* terminate */
};
