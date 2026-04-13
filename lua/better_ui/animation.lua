local M = {}

M.plugins = {
	{
		'echasnovski/mini.animate',
		version = '*',
		config = function()
			require('mini.animate').setup({
				cursor = {
					enable = true,
				},
				scroll = {
					enable = true,
				},
				resize = {
					enable = true,
				},
				open = {
					enable = true,
				},
				close = {
					enable = true,
				},
			})
		end,
	},
}

return M
