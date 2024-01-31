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
			map('n', '<leader>ef', ':Telescope file_browser<CR>', opt)
		end,
	},
}

return M
