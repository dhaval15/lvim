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
	writing = {
		fountain = true,
	},
 	help = {
		cheatsheet = true,
		-- which_key = true,
	},
	ai = {
		-- openai = true,
	}
}

modules.init(config)

-- Define a function to check if the script exists and execute it
function send_r_to_kitty()
    local script_path = vim.fn.getcwd() .. '/send_to_kitty.sh'
    if vim.fn.filereadable(script_path) == 1 then
        vim.fn.system(script_path)
    end
end

-- Trigger the function when saving a Dart file
vim.api.nvim_exec([[
    autocmd BufWritePost *.dart lua send_r_to_kitty()
]], false)


require('capture')

-- Map commands or keybindings to plugin functions

