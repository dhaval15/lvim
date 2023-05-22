local M = {}

M.plugins = {
	{
		'andymass/vim-matchup',
		setup = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
}

return M
