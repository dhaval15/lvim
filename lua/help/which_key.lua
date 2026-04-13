local M = {}

M.plugins = {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		config = function()
			local wk = require('which-key')
			wk.setup({
				delay = 400,
				icons = { mappings = false },
			})

			-- Group labels so the popup is organised
			wk.add({
				{ '<leader>f',  group = 'Flutter' },
				{ '<leader>c',  group = 'Copilot' },
				{ '<leader>t',  group = 'Terminal' },
				{ '<leader>g',  group = 'Git / Go-to' },
				{ '<leader>n',  group = 'Notes' },
				{ '<leader>d',  group = 'DAP' },
				{ '<leader>s',  group = 'Save / Source' },
				{ '<leader>w',  group = 'Workspace' },
				{ '<leader>e',  group = 'Explorer' },
				{ 'g',          group = 'Go-to / LSP' },
			})
		end,
	},
}

return M
