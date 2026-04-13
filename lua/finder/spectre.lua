local M = {}

M.plugins = {
	{
		'nvim-pack/nvim-spectre',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('spectre').setup()
		end,
	},
}

return M
