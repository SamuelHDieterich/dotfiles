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
