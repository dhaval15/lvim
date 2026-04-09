local M = {}
M.plugins = {
	{
		'sainnhe/gruvbox-material',
		-- config = function() vim.cmd [[colorscheme gruvbox-material]] end,
	},
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		config = function() vim.cmd [[colorscheme gruvbox-material]] end,
	},
}
return M
