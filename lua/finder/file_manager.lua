local M = {}

M.plugins = {
	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = {
			{ 
				'nvim-telescope/telescope.nvim',
				'nvim-lua/plenary.nvim',
			},
		},
		config = function()
			local opt = {
				noremap = true,
				silent = true,
			}
			local map = vim.keymap.set
			require('telescope').load_extension('file_browser')
			map('n', '<leader>eF', ':Telescope file_browser<CR>', opt)
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
			local map = vim.keymap.set
			map('n', '<leader>ef', ':NvimTreeToggle source=filesystem<CR>', opt)
		end,
	}
}

return M
