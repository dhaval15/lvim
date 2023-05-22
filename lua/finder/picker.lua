local M = {}
M.plugins = {
	{
		'axkirillov/easypick.nvim',
		config = function()
			local easypick = require("easypick")
			easypick.setup({
				pickers = {
					{
						name = 'spy_list',
						command = 'spy :list',
						previewer = easypick.previewers.default(),
						action = easypick.actions.nvim_command('cd'),
					},
					{
						name = 'spy_actions',
						command = 'spy :actions',
						previewer = easypick.previewers.default(),
						action = easypick.actions.nvim_command('!spy'),
					},
				},
			})
		end,
	},
}

return M
