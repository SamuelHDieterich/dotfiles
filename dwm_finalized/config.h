/* appearance */
static const unsigned int borderpx       = 0;   /* border pixel of windows */
static const int corner_radius           = 15;
static const unsigned int snap           = 32;  /* snap pixel */
#include "config/gaps.h"
static const int showbar                 = 1;   /* 0 means no bar */
static const int topbar                  = 0;   /* 0 means bottom bar */
/* Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor) */
static const int statusmon               = -1;
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int showsystray             = 1;   /* 0 means no systray */
/* Indicators: see patch/bar_indicators.h for options */
static int tagindicatortype              = INDICATOR_BOTTOM_BAR_SLIM;	// changed
static int tiledindicatortype            = INDICATOR_NONE;
static int floatindicatortype            = INDICATOR_BOTTOM_BAR_SLIM;	// changed
static const char *fonts[]               = { 
	"JetBrainsMono:style=Regular:pixelsize=10:antialias=true", 
	"FontAwesome5Free:style=Solid:pixelsize=10:antialias=true", 
	"FontAwesome5Brands:style=Solid:pixelsize=10:antialias=true", 
	"MaterialDesignIcons:pixelsize=12:antialias=true" 
	};

#include "config/themes/alpha_bar.h"

#include "config/autostart.h"

static char *tagicons[][NUMTAGS] = {
	/*						 home  dir  dev	 net chat video music game art						*/
	[DEFAULT_TAGS]        = { "", "", "", "", "", "", "", "", "" },
};

#include "config/rules.h"

static const BarRule barrules[] = {
	/* monitor   bar    alignment         widthfunc                drawfunc                clickfunc                name */
	{ -1,        0,     BAR_ALIGN_LEFT,   width_tags,              draw_tags,              click_tags,              "tags" },
	{ 'A',       0,     BAR_ALIGN_RIGHT,  width_systray,           draw_systray,           click_systray,          	"systray" },
	{ -1,        0,     BAR_ALIGN_LEFT,   width_ltsymbol,          draw_ltsymbol,          click_ltsymbol,          "layout" },
	{ -1, 0,            BAR_ALIGN_RIGHT,  width_status,            draw_status,            click_statuscmd,         "status" },
	{ -1,        0,     BAR_ALIGN_NONE,   width_wintitle,          draw_wintitle,          click_wintitle,          "wintitle" },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },    /* first entry is default */
	{ "",      NULL },    /* no layout function means floating behavior */
	{ "",      monocle },
};

/* This defines the name of the executable that handles the bar (used for signalling purposes) */
#define STATUSBAR "dwmblocks"


#include "config/keys.h"

#include "config/buttons.h"
