// LIBRARY
#include <X11/XF86keysym.h>
 
// APPEARANCE
static const unsigned int borderpx			= 0;	// Border pixel of windows
static const int corner_radius				= 15;	// Corner radius of windows (when # windows > 1, ideally)
static const unsigned int snap				= 32;	// Snap pixel

// GAPS
static const unsigned int gappih			= 14;	// Horizontal inner gap between windows
static const unsigned int gappiv			= 14;	// Vertical inner gap between windows
static const unsigned int gappoh			= 14;	// Horizontal outer gap between windows and screen edge
static const unsigned int gappov			= 14;	// Vertical outer gap between windows and screen edge
static const int smartgaps_fact				= 0;	// Gap factor when there is only one client; 0 = no gaps, 3 = 3x outer gaps

// BAR
static const int showbar					= 1;	// 0 (no bar) | 1 (with bar)
static const int topbar						= 0;	// 0 (bottom) | 1 (top)

// STATUSBAR
// Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor)
static const int statusmon					= -1;

// SYSTRAY
static const unsigned int systrayspacing	= 2;	// Systray spacing (px)
static const int showsystray				= 1;	// 0 (no systray) | 1 (with systray)

// INDICATORS
// See patch/bar_indicators.h for options
static int tagindicatortype					= INDICATOR_BOTTOM_BAR_SLIM;
static int tiledindicatortype				= INDICATOR_NONE;
static int floatindicatortype				= INDICATOR_BOTTOM_BAR_SLIM;

// FONTS
static const char *fonts[] = { 
	"JetBrainsMono:style=Regular:pixelsize=10:antialias=true",		// Default 
	"FontAwesome5Free:style=Solid:pixelsize=10:antialias=true",		// Icons 
	"FontAwesome5Brands:style=Solid:pixelsize=10:antialias=true",	// Icons 
};

// COLOR
#include "config/themes/monocolor.h"

// AUTOSTART
#include "config/autostart.h"

// TAGS
// Read dwm-flexipatch documentation to understand the NUMTAGS macro.
static char *tagicons[][NUMTAGS] = {
	//					home	dir		dev		net		chat	video	music	game	art
	[DEFAULT_TAGS] = {	"",	"",	"",	"",	"",	"",	"",	"",	""	}

// RULES
#include "config/rules.h"

// BAR
// Monitor: -1 (all monitor) | 0 (monitor 0) | 'A' (active monitor)
// Bar: 0 (default) | 1 (extrabar)
// Alignment: how the module is aligned compared to other modules
// Name: visual and debugging
static const BarRule barrules[] = {
	//	monitor		bar		alignment			widthfunc			drawfunc		clickfunc			name
	{	-1,			0,		BAR_ALIGN_LEFT,		width_tags,			draw_tags,		click_tags,			"tags"		},
	{	-1,			0,		BAR_ALIGN_LEFT,		width_ltsymbol,		draw_ltsymbol,	click_ltsymbol,		"layout"	},
	{	-1,			0,		BAR_ALIGN_NONE,		width_wintitle,		draw_wintitle,	click_wintitle,		"wintitle"	},
	{	-1,			0,		BAR_ALIGN_RIGHT,	width_status,		draw_status,	click_statuscmd,	"status"	},
	{	'A',		0,		BAR_ALIGN_RIGHT,	width_systray,		draw_systray,	click_systray,		"systray"	},
};

// LAYOUTS
static const float mfact     = 0.50; // Factor of master area size
static const int nmaster     = 1;    // Number of clients in master area
static const int resizehints = 0;    // 1 means respect size hints in tiled resizals
static const Layout layouts[] = {
	//	symbol		arrange		function
	{	"",		tile 					},	// First entry is default
	{	"",		NULL 					},  // No layout function means floating behavior
	{	"",		monocle					},
};

// DMENU
static char dmenumon[2] = "0";
static const char *dmenucmd[] = {
	"dmenu_run_history",			// Dmenu with cached history
	"-m", dmenumon,
	NULL
};

// TERMINAL
static const char *termcmd[]  = { "kitty", NULL };

// STATUSBAR
#define STATUSBAR "dwmblocks"	// This defines the name of the executable that handles the bar (used for signalling purposes)

// SHELL
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

// KEY
#include "config/key.h"

// BUTTON
#include "config/buttons.h"
