local M = {}

M.plugins = {
	{
		'nvim-orgmode/orgmode',
		config = function ()
			require('orgmode').setup_ts_grammar()
		end,
	},
}
return M
