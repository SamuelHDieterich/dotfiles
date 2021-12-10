static const char *const autostart[] = {
	"picom", NULL,																	// Compositor
	"feh", "--bg-scale", "/home/samuel/Pictures/wallpaper.jpg", NULL,				// Wallpaper
	"setxkbmap", "-model", "pc104", "-layout", "br", "-variant", "thinkpad", NULL,	// Keyboard
	"dwmblocks", NULL,																// Statusbar
	NULL																			// Terminate
};
