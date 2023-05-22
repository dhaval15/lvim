local M = {}

M.plugins = {
	{
		'akinsho/bufferline.nvim',
		--tag = 'v2.*', 
		dependencies = {
			{ 'kyazdani42/nvim-web-devicons' },
		},
		config = function()
			require('bufferline').setup{}
		end,
	},
}

return M
