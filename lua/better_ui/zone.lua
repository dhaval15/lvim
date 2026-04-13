local M = {}

M.plugins = {
	{
		'tamton-aquib/zone.nvim',
		config = function()
			require('zone').setup({
				style        = 'treadmill',  -- treadmill | dvd | epilepsy | vanish | matrix
				after        = 60,           -- seconds of inactivity before screensaver
				exclude_filetypes = {
					'toggleterm',
					'TelescopePrompt',
					'neo-tree',
				},
			})
		end,
	},
}

return M
