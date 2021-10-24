/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx       = 0;   /* border pixel of windows */
static const int corner_radius           = 15;
static const unsigned int snap           = 32;  /* snap pixel */
static const unsigned int gappih         = 14;  /* horiz inner gap between windows */
static const unsigned int gappiv         = 14;  /* vert inner gap between windows */
static const unsigned int gappoh         = 14;  /* horiz outer gap between windows and screen edge */
static const unsigned int gappov         = 14;  /* vert outer gap between windows and screen edge */
static const int smartgaps_fact          = 0;   /* gap factor when there is only one client; 0 = no gaps, 3 = 3x outer gaps */
static const int showbar                 = 1;   /* 0 means no bar */
static const int topbar                  = 0;   /* 0 means bottom bar */
static const int bar_height              = 20;   /* 0 means derive from font, >= 1 explicit height */
/* Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor) */
static const int statusmon               = -1;
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int showsystray             = 1;   /* 0 means no systray */
/* Indicators: see patch/bar_indicators.h for options */
static int tagindicatortype              = INDICATOR_BOTTOM_BAR_SLIM;	// changed
static int tiledindicatortype            = INDICATOR_NONE;
static int floatindicatortype            = INDICATOR_BOTTOM_BAR_SLIM;				// changed
static const char *fonts[]               = { 
	"JetBrainsMono:style=Regular:pixelsize=10:antialias=true", 
	"FontAwesome5Free:style=Solid:pixelsize=10:antialias=true", 
	"FontAwesome5Brands:style=Solid:pixelsize=10:antialias=true", 
	"MaterialDesignIcons:pixelsize=12:antialias=true" 
	};
static const char dmenufont[]            = "JetBrainsMono:size=14:antialias=true";

static char c000000[]                    = "#000000"; // placeholder value

static char normfgcolor[]                = "#aaaaaa";
static char normbgcolor[]                = "#050505";
static char normbordercolor[]            = "#000000";
static char normfloatcolor[]             = "#000000";

static char selfgcolor[]                 = "#ffffff";
static char selbgcolor[]                 = "#050505";
static char selbordercolor[]             = "#000000";
static char selfloatcolor[]              = "#000000";

static char titlenormfgcolor[]           = "#dddddd";
static char titlenormbgcolor[]           = "#050505";
static char titlenormbordercolor[]       = "#000000";
static char titlenormfloatcolor[]        = "#000000";

static char titleselfgcolor[]            = "#f0f0f0";
static char titleselbgcolor[]            = "#050505";
static char titleselbordercolor[]        = "#000000";
static char titleselfloatcolor[]         = "#000000";

static char tagsnormfgcolor[]            = "#aaaaaa";
static char tagsnormbgcolor[]            = "#050505";
static char tagsnormbordercolor[]        = "#000000";
static char tagsnormfloatcolor[]         = "#000000";

static char tagsselfgcolor[]             = "#ffffff";
static char tagsselbgcolor[]             = "#050505";
static char tagsselbordercolor[]         = "#000000";
static char tagsselfloatcolor[]          = "#000000";

static char hidnormfgcolor[]             = "#888888";
static char hidselfgcolor[]              = "#050505";
static char hidnormbgcolor[]             = "#000000";
static char hidselbgcolor[]              = "#000000";

static char urgfgcolor[]                 = "#ffffff";
static char urgbgcolor[]                 = "#050505";
static char urgbordercolor[]             = "#000000";
static char urgfloatcolor[]              = "#000000";



static char *colors[][ColCount] = {
	/*                       foreground        background        border                float 				*/
	[SchemeNorm]         = { normfgcolor,      normbgcolor,      normbordercolor,      normfloatcolor },
	[SchemeSel]          = { selfgcolor,       selbgcolor,       selbordercolor,       selfloatcolor },
	[SchemeTitleNorm]    = { titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor },
	[SchemeTitleSel]     = { titleselfgcolor,  titleselbgcolor,  titleselbordercolor,  titleselfloatcolor },
	[SchemeTagsNorm]     = { tagsnormfgcolor,  tagsnormbgcolor,  tagsnormbordercolor,  tagsnormfloatcolor },
	[SchemeTagsSel]      = { tagsselfgcolor,   tagsselbgcolor,   tagsselbordercolor,   tagsselfloatcolor },
	[SchemeHidNorm]      = { hidnormfgcolor,   hidnormbgcolor,   c000000,              c000000 },
	[SchemeHidSel]       = { hidselfgcolor,    hidselbgcolor,    c000000,              c000000 },
	[SchemeUrg]          = { urgfgcolor,       urgbgcolor,       urgbordercolor,       urgfloatcolor },
};



static const char *const autostart[] = {
	"picom", NULL,																	// Compositor
	"xrandr", "--output", "HDMI-1-1", "--auto", "--right-of", "eDP-1-1", NULL,		// 2 monitors
	"mons", "-a", NULL,																// Monitors daemon
	"nitrogen", "--restore", NULL,													// Wallpaper
	"dwmblocks", NULL,																// Status
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", NULL,				// Polkit
	"nm-applet", NULL,																// Network
	"volumeicon", NULL,																// Volume
	"setxkbmap", "-model", "pc104", "-layout", "br", "-variant", "thinkpad", NULL,	// Keyboard
	NULL /* terminate */
};


/* Tags */
static char *tagicons[][NUMTAGS] = {
	/*						 home  dir  dev	 net chat video music game art						*/
	[DEFAULT_TAGS]        = { "", "", "", "", "", "", "", "", "" }
};


/* There are two options when it comes to per-client rules:
 *  - a typical struct table or
 *  - using the RULE macro
 *
 * A traditional struct table looks like this:
 *    // class      instance  title  wintype  tags mask  isfloating  monitor
 *    { "Gimp",     NULL,     NULL,  NULL,    1 << 4,    0,          -1 },
 *    { "Firefox",  NULL,     NULL,  NULL,    1 << 7,    0,          -1 },
 *
 * The RULE macro has the default values set for each field allowing you to only
 * specify the values that are relevant for your rule, e.g.
 *
 *    RULE(.class = "Gimp", .tags = 1 << 4)
 *    RULE(.class = "Firefox", .tags = 1 << 7)
 *
 * Refer to the Rule struct definition for the list of available fields depending on
 * the patches you enable.
 */
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
	
    RULE(.wintype = WTYPE "DIALOG",	    .isfloating = 1,    .iscentered = 1)
	RULE(.wintype = WTYPE "UTILITY",    .isfloating = 1,    .iscentered = 1)
	RULE(.wintype = WTYPE "TOOLBAR",    .isfloating = 1,    .iscentered = 1)
	RULE(.wintype = WTYPE "SPLASH",     .isfloating = 1,    .iscentered = 1)

	RULE(.class = "VSCodium",						.tags = 1 << 2, .switchtag = 1)
	RULE(.class = "Brave", 							.tags = 1 << 3, .switchtag = 1)
	RULE(.class = "Signal", 						.tags = 1 << 4)
	RULE(.class = "Microsoft Teams - Preview", 		.tags = 1 << 5, .switchtag = 1)
	RULE(.class = "spotify",						.tags = 1 << 6)
	RULE(.class = "Steam", .title = "Steam",			.tags = 1 << 7, .switchtag = 1)
	RULE(.class = "Steam", .title = "Lista de amigos",	.isfloating = 1, .iscentered = 1)
	RULE(.class = "Pavucontrol", 						.isfloating = 1, .iscentered = 1)
	RULE(.class = "Nm-connection-editor", 				.isfloating = 1, .iscentered = 1)
};



/* Bar rules allow you to configure what is shown where on the bar, as well as
 * introducing your own bar modules.
 *
 *    monitor:
 *      -1  show on all monitors
 *       0  show on monitor 0
 *      'A' show on active monitor (i.e. focused / selected) (or just -1 for active?)
 *    bar - bar index, 0 is default, 1 is extrabar
 *    alignment - how the module is aligned compared to other modules
 *    widthfunc, drawfunc, clickfunc - providing bar module width, draw and click functions
 *    name - does nothing, intended for visual clue and for logging / debugging
 */
static const BarRule barrules[] = {
	/* monitor   bar    alignment         widthfunc                drawfunc                clickfunc                name */
	{ -1,        0,     BAR_ALIGN_LEFT,   width_tags,              draw_tags,              click_tags,              "tags" },
	{ 'A',        0,     BAR_ALIGN_RIGHT,  width_systray,           draw_systray,           click_systray,          "systray" },            // If -1 don't work, change to 'A'
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


/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      comboview,      {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      combotag,       {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },



/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
	"dmenu_run_history",            // Changed to a script
	"-m", dmenumon,
	"-fn", dmenufont,
	"-nb", normbgcolor,
	"-nf", normfgcolor,
	"-sb", selbgcolor,
	"-sf", selfgcolor,
	NULL
};
static const char *termcmd[]  = { "alacritty", NULL };

/* This defines the name of the executable that handles the bar (used for signalling purposes) */
#define STATUSBAR "dwmblocks"


static Key keys[] = {
	/* MODIFIER                     KEY                         FUNCTION                ARGUMENT                        */
    // AUDIO
    { 0,                     	    XF86XK_AudioNext, 			spawn, 			        SHCMD("playerctl next") 		},
	{ 0,                       	    XF86XK_AudioPrev, 			spawn, 			        SHCMD("playerctl previous")     },
	{ 0,                       	    XF86XK_AudioPlay, 			spawn, 			        SHCMD("playerctl play-pause")   },
	{ 0,                       	    XF86XK_AudioPause, 			spawn, 			        SHCMD("playerctl play-pause")   },
	{ 0,                       	    XF86XK_AudioStop, 			spawn, 			        SHCMD("playerctl stop") 		},
    // { 0,                     	    XF86XK_AudioLowerVolume, 	spawn, 			        SHCMD("pactl set-sink-volume 0 -3%; pkill -RTMIN+10 dwmblocks") },
	// { 0,                       	    XF86XK_AudioMute, 			spawn, 			        SHCMD("pactl set-sink-mute 0 toggle; pkill -RTMIN+10 dwmblocks") },
	// { 0,                       	    XF86XK_AudioRaiseVolume, 	spawn, 			        SHCMD("pactl set-sink-volume 0 +3%; pkill -RTMIN+10 dwmblocks") },
    // SCREEN
	{ 0,						    XF86XK_MonBrightnessDown,	spawn,			        SHCMD("brightnessctl s 10%-")   },
	{ 0,						    XF86XK_MonBrightnessUp,		spawn,			        SHCMD("brightnessctl s +10%")   },
    // SCREENSHOT
	{ 0,						    XK_Print,					spawn,			        SHCMD("flameshot gui") 		    },
    // SYSTEM MONITOR
	{ ControlMask|ShiftMask,	    XK_Escape,					spawn,			        SHCMD("alacritty -e btop")	    },
    // FILE MANAGER
	{ MODKEY,					    XK_e,						spawn,			        SHCMD("thunar") 				},
	// BROWSER
	{ MODKEY|Mod1Mask,			    XK_b,						spawn,			        SHCMD("brave") 				    },
	// VSCODIUM
	{ MODKEY|Mod1Mask,			    XK_v,						spawn,			        SHCMD("vscodium") 			    },
	{ MODKEY,                       XK_p,                       spawn,                  {.v = dmenucmd } },
	{ MODKEY,                       XK_Return,                  spawn,                  {.v = termcmd } },
	{ MODKEY,                       XK_b,                       togglebar,              {0} },
	{ MODKEY,                       XK_j,                       focusstack,             {.i = +1 } },
	{ MODKEY,                       XK_k,                       focusstack,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_j,                       rotatestack,            {.i = +1 } },
	{ MODKEY|Mod4Mask,              XK_k,                       rotatestack,            {.i = -1 } },
	{ MODKEY,                       XK_i,          				incnmaster,             {.i = +1 } },
	{ MODKEY,                       XK_d,          				incnmaster,             {.i = -1 } },
	{ MODKEY,                       XK_h,          				setmfact,               {.f = -0.05} },
	{ MODKEY,                       XK_l,          				setmfact,               {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_j,          				movestack,              {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,          				movestack,              {.i = -1 } },
	{ MODKEY,                       XK_plus,       				zoom,                   {0} },
	{ MODKEY|Mod4Mask,              XK_u,          				incrgaps,               {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,          				incrgaps,               {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,          				incrigaps,              {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,          				incrigaps,              {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,          				incrogaps,              {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,          				incrogaps,              {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,          				incrihgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,          				incrihgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,          				incrivgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,          				incrivgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,          				incrohgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,          				incrohgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,          				incrovgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,          				incrovgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,          				togglegaps,             {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,          				defaultgaps,            {0} },
	{ MODKEY,                       XK_Tab,        				view,                   {0} },
	{ MODKEY|ShiftMask,             XK_Tab,        				shiftviewclients,       { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_backslash,  				shiftviewclients,       { .i = +1 } },
	{ MODKEY,             			XK_c,          				killclient,             {0} },
    { Mod1Mask,                     XK_F4,         				killclient,             {0} },
	{ MODKEY|ShiftMask,             XK_q,          				quit,                   {0} },
	{ MODKEY,                       XK_t,          				setlayout,              {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,          				setlayout,              {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,          				setlayout,              {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,      				setlayout,              {0} },
	{ MODKEY|ShiftMask,             XK_space,      				togglefloating,         {0} },
	{ MODKEY,                       XK_0,          				view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          				tag,                    {.ui = ~0 } },
	{ MODKEY,                       XK_comma,      				focusmon,               {.i = -1 } },
	{ MODKEY,                       XK_period,     				focusmon,               {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      				tagmon,                 {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     				tagmon,                 {.i = +1 } },
	TAGKEYS(                        XK_1,                                  0)
	TAGKEYS(                        XK_2,                                  1)
	TAGKEYS(                        XK_3,                                  2)
	TAGKEYS(                        XK_4,                                  3)
	TAGKEYS(                        XK_5,                                  4)
	TAGKEYS(                        XK_6,                                  5)
	TAGKEYS(                        XK_7,                                  6)
	TAGKEYS(                        XK_8,                                  7)
	TAGKEYS(                        XK_9,                                  8)
};


/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask           button          function        argument */
	{ ClkLtSymbol,          0,                   Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,                   Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,                   Button2,        zoom,           {0} },
	{ ClkStatusText,        0,                   Button1,        sigstatusbar,   {.i = 1 } },	// left click
	{ ClkStatusText,        0,                   Button2,        sigstatusbar,   {.i = 2 } },	// middle click
	{ ClkStatusText,        0,                   Button3,        sigstatusbar,   {.i = 3 } },	// right click
	{ ClkStatusText,        0,                   Button4,        sigstatusbar,   {.i = 4 } },	// scroll wheel up
	{ ClkStatusText,        0,                   Button5,        sigstatusbar,   {.i = 5 } },	// scroll wheel down
	{ ClkClientWin,         MODKEY,              Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,              Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,              Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,                   Button1,        view,           {0} },
	{ ClkTagBar,            0,                   Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,              Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,              Button3,        toggletag,      {0} },
};



