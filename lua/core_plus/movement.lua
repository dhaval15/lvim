local M = {}
M.plugins = {
	{
		url = 'https://codeberg.org/andyg/leap.nvim',
		config = function()
			vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
			vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
			vim.keymap.set({'n', 'x', 'o'}, 'gz', '<Plug>(leap-from-window)')
		end,
	},
}
return M
