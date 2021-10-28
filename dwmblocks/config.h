#define CMDLENGTH 30
#define DELIMITER " | "
#define LEADING_DELIMITER
#define CLICKABLE_BLOCKS

const Block blocks[] = {
	BLOCK("sb-cpu",    		2, 		20)
	BLOCK("sb-gpu",   		2,    	20)
	BLOCK("sb-memory",  	2, 		20)
	BLOCK("sb-internet",	60,		13)
	BLOCK("sb-update",  	180, 	12)
	BLOCK("sb-volume",  	0,    	11)
	BLOCK("sb-date", 		10, 	20)
	BLOCK("sb-time", 		10, 	20)
	BLOCK("sb-battery", 	60,    	20)
};
