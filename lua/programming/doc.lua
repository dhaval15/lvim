local M = {}
M.plugins = {
	{
		'danymat/neogen',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		config = true,
	},
}
return M
