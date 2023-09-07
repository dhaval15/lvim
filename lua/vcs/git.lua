local M = {}

M.plugins = {
	{
		'TimUntersberger/neogit',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		config = function()
			local neogit = require('neogit')
			neogit.setup()
		end,
	},
}

return M
