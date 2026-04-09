local M = {}

M.plugins = {
	{
		'github/copilot.vim',
		dependencies = {
			-- { 
			-- 	'nvim-telescope/telescope.nvim',
			-- 	'nvim-lua/plenary.nvim',
			-- },
		},
		config = function()
			-- local opt = {
			-- 	noremap = true,
			-- 	silent = true,
			-- }
			-- local map = vim.keymap.set
			-- require('telescope').load_extension('file_browser')
			-- map('n', '<leader>eF', ':Telescope file_browser<CR>', opt)
		end,
	},
	{
		'CopilotC-Nvim/CopilotChat.nvim',
		dependencies = {
			'github/copilot.vim',
		},
	}
}

return M
