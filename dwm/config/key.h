#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      comboview,      {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      combotag,       {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

static Key keys[] = {
	//	MODIFIER							KEY                         FUNCTION                ARGUMENT
	{	0,									XF86XK_AudioNext,			spawn,					SHCMD("playerctl next") 							},
	{	0,									XF86XK_AudioPrev,			spawn,					SHCMD("playerctl previous")							},
	{	0,									XF86XK_AudioPlay,			spawn,					SHCMD("playerctl play-pause")						},
	{	0,									XF86XK_AudioPause,			spawn,					SHCMD("playerctl play-pause")						},
	{	0,									XF86XK_AudioStop,			spawn,					SHCMD("playerctl stop")								},
	{	0,									XF86XK_AudioLowerVolume,	spawn,					SHCMD("pamixer -d 3; kill -45 $(pidof dwmblocks)")	},
	{	0,									XF86XK_AudioMute,			spawn,					SHCMD("pamixer -t; kill -45 $(pidof dwmblocks)")	},
	{	0,									XF86XK_AudioRaiseVolume,	spawn,					SHCMD("pamixer -i 3; kill -45 $(pidof dwmblocks)")	},
	{	0,									XF86XK_MonBrightnessDown,	spawn,					SHCMD("brightnessctl s 10%-")						},
	{	0,									XF86XK_MonBrightnessUp,		spawn,					SHCMD("brightnessctl s +10%")						},
	{	0,									XK_Print,					spawn,					SHCMD("flameshot gui")								},
	{	ControlMask|ShiftMask,				XK_Escape,					spawn,					SHCMD("$TERMINAL -e btop")							},
	{	MODKEY,								XK_e,						spawn,					SHCMD("pcmanfm")									},
	{	MODKEY|Mod1Mask,					XK_b,						spawn,					SHCMD("librewolf")									},
	{	MODKEY|Mod1Mask,					XK_v,						spawn,					SHCMD("vscodium")									},
	{	MODKEY,								XK_p,						spawn,					{.v = dmenucmd }									},
	{	MODKEY,								XK_Return,					spawn,					{.v = termcmd }										},
	{	MODKEY,								XK_b,						togglebar,				{0}													},
	{	MODKEY,								XK_j,						focusstack,				{.i = +1 }											},
	{	MODKEY,								XK_k,						focusstack,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_j,						rotatestack,			{.i = +1 }											},
	{	MODKEY|Mod4Mask,					XK_k,						rotatestack,			{.i = -1 }											},
	{	MODKEY,								XK_i,						incnmaster,				{.i = +1 }											},
	{	MODKEY,								XK_d,						incnmaster,				{.i = -1 }											},
	{	MODKEY,								XK_h,						setmfact,				{.f = -0.05}										},
	{	MODKEY,								XK_l,						setmfact,				{.f = +0.05}										},
	{	MODKEY|ShiftMask,					XK_j,						movestack,				{.i = +1 }											},
	{	MODKEY|ShiftMask,					XK_k,						movestack,				{.i = -1 }											},
	{	MODKEY,								XK_plus,					zoom,					{0}													},
	{	MODKEY|Mod4Mask,					XK_u,						incrgaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_u,						incrgaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_i,						incrigaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_i,						incrigaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_o,						incrogaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_o,						incrogaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_6,						incrihgaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_6,						incrihgaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_7,						incrivgaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_7,						incrivgaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_8,						incrohgaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_8,						incrohgaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_9,						incrovgaps,				{.i = +1 }											},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_9,						incrovgaps,				{.i = -1 }											},
	{	MODKEY|Mod4Mask,					XK_0,						togglegaps,				{0}													},
	{	MODKEY|Mod4Mask|ShiftMask,			XK_0,						defaultgaps,			{0}													},
	{	MODKEY,								XK_Tab,						view,					{0}													},
	{	MODKEY|ShiftMask,					XK_Tab,						shiftviewclients,		{ .i = -1 }											},
	{	MODKEY|ShiftMask,					XK_backslash,				shiftviewclients,		{ .i = +1 }											},
	{	MODKEY,								XK_c,						killclient,				{0}													},
	{	Mod1Mask,							XK_F4,						killclient,				{0}													},
	{	MODKEY|ShiftMask,					XK_q,						quit,					{0}													},
	{	MODKEY,								XK_t,						setlayout,				{.v = &layouts[0]}									},
	{	MODKEY,								XK_f,						setlayout,				{.v = &layouts[1]}									},
	{	MODKEY,								XK_m,						setlayout,				{.v = &layouts[2]}									},
	{	MODKEY,								XK_space,					setlayout,				{0}													},
	{	MODKEY|ShiftMask,					XK_space,					togglefloating,			{0}													},
	{	MODKEY,								XK_0,						view,					{.ui = ~0 }											},
	{	MODKEY|ShiftMask,					XK_0,						tag,					{.ui = ~0 }											},
	{	MODKEY,								XK_comma,					focusmon,				{.i = -1 }											},
	{	MODKEY,								XK_period,					focusmon,				{.i = +1 }											},
	{	MODKEY|ShiftMask,					XK_comma,					tagmon,					{.i = -1 }											},
	{	MODKEY|ShiftMask,					XK_period,					tagmon,					{.i = +1 }											},
	TAGKEYS(								XK_1,						0)
	TAGKEYS(								XK_2,						1)
	TAGKEYS(								XK_3,						2)
	TAGKEYS(								XK_4,						3)
	TAGKEYS(								XK_5,						4)
	TAGKEYS(								XK_6,						5)
	TAGKEYS(								XK_7,						6)
	TAGKEYS(								XK_8,						7)
	TAGKEYS(								XK_9,						8)
};