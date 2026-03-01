require("git"):setup()
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode="dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = false,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})
require("duckdb"):setup({
  mode = "standard",      	-- Default: "summarized"
  cache_size = 1000,        -- Default: 500
  row_id = "dynamic",       -- Default: false
  minmax_column_width = 21, -- Default: 21
  column_fit_factor = 10.0,	-- Default: 10.0
})