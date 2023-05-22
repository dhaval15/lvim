local M = {}

M.plugins = {
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup{
				padding = true, -- space b/w comment and line
				sticky = true, -- cursor should stay at its position
				ignore = nil, -- Lines to be ignored while (un)comment
				toggler = {
						line = 'gcc',
						block = 'gbc',
				},
				opleader = {
						line = 'gc', --line
						block = 'gb', -- block
				},
				extra = {
						above = 'gcO', -- above
						below = 'gco', -- below
						eol = 'gcA', -- end of line
				},
				mappings = {
						basic = true,
						extra = true,
				},
				pre_hook = nil, -- function before (un)comment
				post_hook = nil, -- function before (un)comment
			}
		end,
	},
}

return M
