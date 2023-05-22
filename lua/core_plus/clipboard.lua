local M = {}
M.plugins = {
	{
		'AckslD/nvim-neoclip.lua',
		dependencies = {
			{'nvim-telescope/telescope.nvim'},
		},
		config = function()
			require('neoclip').setup()
			local opt = {
				noremap = true,
				silent = true,
			}
			local map = vim.keymap.set
			local neoclip = require('telescope').extensions.neoclip.default
			map('n', '<leader>yy', neoclip, opt)
		end,
	},
}
return M
