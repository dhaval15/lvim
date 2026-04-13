local M = {}

M.plugins = {
	{
		'folke/edgy.nvim',
		event = 'VeryLazy',
		config = function()
			require('edgy').setup({
				bottom = {
					{
						ft       = 'toggleterm',
						size     = { height = 15 },
						filter   = function(_, win)
							return vim.api.nvim_win_get_config(win).relative == ''
						end,
					},
					{ ft = 'dap-repl',        title = 'DAP Console', size = { height = 14 } },
					{ ft = 'dapui_console',   title = 'DAP Output',  size = { height = 14 } },
					{ ft = '__FLUTTER_DEV_LOG__', title = 'Flutter Log', size = { height = 14 } },
					{ ft = 'qf',              title = 'Quickfix' },
				},
				right = {
					{ ft = 'flutter_outline', title = 'Flutter Outline', size = { width = 35 } },
					{ ft = 'dapui_scopes',    title = 'Variables',       size = { width = 35 } },
					{ ft = 'dapui_breakpoints', title = 'Breakpoints',   size = { width = 35 } },
					{ ft = 'dapui_stacks',    title = 'Call Stack',      size = { width = 35 } },
					{ ft = 'dapui_watches',   title = 'Watches',         size = { width = 35 } },
				},
				left = {
					{ ft = 'neo-tree', title = 'Files', size = { width = 35 } },
				},
				options = {
					left   = { size = 35 },
					right  = { size = 35 },
					bottom = { size = 14 },
				},
				animate = { enabled = true },
			})
		end,
	},
}

return M
