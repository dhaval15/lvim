local M = {}

M.plugins = {
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'nvim-neotest/nvim-nio',
			{
				'rcarriga/nvim-dap-ui',
				config = function()
					local dap = require('dap')
					local dapui = require('dapui')
					dapui.setup({
						layouts = {
							{
								elements = { { id = 'console', size = 1.0 } },
								size = 14,
								position = 'bottom',
							},
						},
					})
					-- Auto-open/close UI with debug sessions
					dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
					dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
					dap.listeners.before.event_exited['dapui_config']     = function() dapui.close() end
				end,
			},
		},
		config = function()
			local opt = { noremap = true, silent = true }
			local map = vim.keymap.set
			local dap = require('dap')

			-- Breakpoints & control
			map('n', 'g.', dap.toggle_breakpoint, opt)
			map('n', '<F5>',  dap.continue, opt)
			map('n', '<F10>', dap.step_over, opt)
			map('n', '<F11>', dap.step_into, opt)
			map('n', '<F12>', dap.step_out, opt)
			map('n', '<leader>du', function() require('dapui').toggle() end, opt)

			dap.adapters.dart = {
				type = 'executable',
				command = 'dart',
				args = { 'debug_adapter' },
			}
		end,
	},
}
return M
