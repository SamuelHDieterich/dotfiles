static char c000000[]                    = "#000000"; // placeholder value

static char normfgcolor[]                = "#bbbbbb";

static char selfgcolor[]                 = "#ffffff";

static char titlenormfgcolor[]           = "#dddddd";

static char titleselfgcolor[]            = "#f0f0f0";

static char tagsnormfgcolor[]            = "#bbbbbb";

static char tagsselfgcolor[]             = "#ffffff";

static char hidnormfgcolor[]             = "#aaaaaa";

static char urgfgcolor[]                 = "#ffffff";


static const unsigned int baralpha = 0x00;
static const unsigned int borderalpha = OPAQUE;
static const unsigned int alphas[][3] = {
	/*                       fg      bg        border     */
	[SchemeNorm]         = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]          = { OPAQUE, baralpha, borderalpha },
	[SchemeTitleNorm]    = { OPAQUE, baralpha, borderalpha },
	[SchemeTitleSel]     = { OPAQUE, baralpha, borderalpha },
	[SchemeTagsNorm]     = { OPAQUE, baralpha, borderalpha },
	[SchemeTagsSel]      = { OPAQUE, baralpha, borderalpha },
	[SchemeHidNorm]      = { OPAQUE, baralpha, borderalpha },
	[SchemeHidSel]       = { OPAQUE, baralpha, borderalpha },
	[SchemeUrg]          = { OPAQUE, baralpha, borderalpha },
};

static char *colors[][ColCount] = {
	/*                       foreground        background        border                float 				*/
	[SchemeNorm]         = { normfgcolor,      	c000000, c000000, c000000,},
	[SchemeSel]          = { c000000,       	c000000, c000000, c000000,},
	[SchemeTitleNorm]    = { titlenormfgcolor, 	c000000, c000000, c000000,},
	[SchemeTitleSel]     = { c000000,  			c000000, c000000, c000000,},
	[SchemeTagsNorm]     = { tagsnormfgcolor,  	c000000, c000000, c000000,},
	[SchemeTagsSel]      = { tagsselfgcolor,   	c000000, c000000, c000000,},
	[SchemeHidNorm]      = { hidnormfgcolor,   	c000000, c000000, c000000,},
	[SchemeHidSel]       = { c000000,    		c000000, c000000, c000000,},
	[SchemeUrg]          = { c000000,       	c000000, c000000, c000000,},
};