local M = {}
M.plugins = {
	{
		'sudormrfbin/cheatsheet.nvim',
		dependencies = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		config = function ()
		end,
	},
}
return M
