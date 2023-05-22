local modules = require('modules')

local config = {
	core = {
		options = true,
		mappings = true,
		commands = true,
	},
	core_plus = {
		editing = true,
		movement = true,
		surround = true,
		clipboard = true,
	},
	better_ui = {
		status = true,
		scheme = true,
		buffer = true,
		layout = false,
		menu = false,
	},
	finder = {
		ui = true,
		file_manager = false,
		picker = true,
	},
 	vcs = {
		git = true,
	},
	notes = {
		orgmode = true,
		focus = true,
		orgroam = true,
	},
	programming = {
		format = true,
		syntax_highlighting = true,
		commentry = true,
		lsp = true,
		completions = true,
		movement = true,
		snippets = true,
		doc = true,
		focus = true,
		extras = true,
	},
 	project = {
		spy = true,
	},
 	help = {
		cheatsheet = true,
	},
}

modules.init(config)
