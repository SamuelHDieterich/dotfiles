/* xprop(1):
 * WM_CLASS(STRING)				= instance, class
 * WM_NAME(STRING)				= title
 * WM_WINDOW_ROLE(STRING)		= role
 * _NET_WM_WINDOW_TYPE(ATOM)	= wintype
*/

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
	RULE(.wintype = WTYPE "DIALOG",				.isfloating = 1,			.iscentered = 1						)
	RULE(.wintype = WTYPE "UTILITY",			.isfloating = 1,			.iscentered = 1						)
	RULE(.wintype = WTYPE "TOOLBAR",			.isfloating = 1,			.iscentered = 1						)
	RULE(.wintype = WTYPE "SPLASH",				.isfloating = 1,			.iscentered = 1						)
	RULE(.class = "VSCodium",					.tags = 1 << 2,				.switchtag = 1						)
	RULE(.class = "LibreWolf", 					.tags = 1 << 3,				.switchtag = 1						)
	RULE(.title = "WhatsApp",					.tags = 1 << 4													)
	RULE(.class = "Signal",						.tags = 1 << 4													)
	RULE(.class = "Microsoft Teams - Preview",	.tags = 1 << 5,				.switchtag = 1						)
	RULE(.class = "Steam",						.title = "Steam",			.tags = 1 << 7,		.switchtag = 1	)
	RULE(.class = "Steam",						.title = "Lista de amigos",	.isfloating = 1,	.iscentered = 1	)
	RULE(.class = "Pavucontrol", 				.isfloating = 1,			.iscentered = 1						)
};
