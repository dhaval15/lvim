local M = {}

M.plugins = {
	{
		'nvim-orgmode/orgmode',
		config = function ()
			require('orgmode')
		end,
	},
}
return M
