local M = {}

M.plugins = {
	{
		'gelguy/wilder.nvim',
		config = function()
			require('wilder').setup({
				modes = {':', '/', '?'},
			})
		end,
	},
}

return M
