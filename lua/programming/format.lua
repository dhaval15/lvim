local M = {}

M.plugins = {
	{
		'foosoft/vim-argwrap',
		config = function() 
			local opt = {
				noremap = true,
				silent = true,
			}
			local map = vim.keymap.set
			map('n', '=aw', ':ArgWrap<CR>', opt)
		end,
	},
}

return M

