local M = {}

M.plugins = {
	{
		'mfussenegger/nvim-dap',
		config = function()
			local opt = {
				noremap = true,
				silent  = true,
			}
			local map = vim.keymap.set
			-- dap
			map("n", "g.", ":lua require('dap').toggle_breakpoint()<CR>", opt)
			local dap = require('dap')

			dap.adapters.dart = {
				type = "executable",
				command = "dart",
				-- This command was introduced upstream in https://github.com/dart-lang/sdk/commit/b68ccc9a
				args = {"debug_adapter"}
			}
		end,
	},
}
return M
