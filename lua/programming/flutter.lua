local M = {}

M.plugins = {
	{
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim',
			'mfussenegger/nvim-dap',
			'rcarriga/nvim-dap-ui',
		},
		config = function()
			require('flutter-tools').setup({
				fvm = true,
				debugger = {
					enabled = true,
					run_via_dap = true,
				},
				widget_guides = {
					enabled = true,
				},
				dev_log = {
					enabled = true,
					notify_errors = true,
					open_cmd = 'botright 12split',
				},
				dev_tools = {
					autostart = false,
				},
				outline = {
					open_cmd = '30vnew',
					auto_open = false,
				},
				lsp = {
					on_attach = function(_, bufnr)
						local opt = { noremap = true, silent = true, buffer = bufnr }
						local map = vim.keymap.set
						map('n', 'K',   vim.lsp.buf.hover, opt)
						map('n', 'gm',  function() require('fastaction').code_action() end, opt)
						map('n', 'gf',  vim.lsp.buf.format, opt)
						map('n', 'gR',  vim.lsp.buf.rename, opt)
						map('n', 'gd',  vim.lsp.buf.definition, opt)
					end,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
					},
				},
			})

			local map = vim.keymap.set
			local opt = { noremap = true, silent = true }

			-- Run & debug
			map('n', '<leader>fr', ':FlutterRun<CR>',     opt)
			map('n', '<leader>fd', ':FlutterDebug<CR>',   opt)
			map('n', '<leader>fq', ':FlutterQuit<CR>',    opt)
			-- Hot reload / restart
			map('n', '<leader>fh', ':FlutterReload<CR>',  opt)
			map('n', '<leader>fH', ':FlutterRestart<CR>', opt)
			-- UI
			map('n', '<leader>fo', ':FlutterOutlineToggle<CR>', opt)
			map('n', '<leader>fl', ':FlutterDevLog<CR>',  opt)
			-- Devices
			map('n', '<leader>fe', ':FlutterEmulators<CR>', opt)
			map('n', '<leader>fD', ':FlutterDevices<CR>',  opt)
		end,
	},
}

return M
