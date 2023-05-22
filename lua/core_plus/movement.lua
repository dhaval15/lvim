local M = {}
M.plugins = {
	{
		'ggandor/leap.nvim',
		config = function()
			require('leap').add_default_mappings()
		end,
	},
}
return M
