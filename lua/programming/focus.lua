local M = {}
M.plugins = {
	{
		'folke/twilight.nvim',
		config = function ()
			require('twilight').setup {
			}
		end
	},
}
return M
