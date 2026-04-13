local M = {}

M.plugins = {
	{
		'TimUntersberger/neogit',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		config = function()
			local neogit = require('neogit')
			neogit.setup()
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup({
				signs = {
					add          = { text = '▎' },
					change       = { text = '▎' },
					delete       = { text = '' },
					topdelete    = { text = '' },
					changedelete = { text = '▎' },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
					virt_text_pos = 'eol',
				},
			})

			local gs  = require('gitsigns')
			local opt = { noremap = true, silent = true }

			vim.keymap.set('n', ']h', gs.next_hunk,               opt)
			vim.keymap.set('n', '[h', gs.prev_hunk,               opt)
			vim.keymap.set('n', '<leader>hs', gs.stage_hunk,      opt)
			vim.keymap.set('n', '<leader>hr', gs.reset_hunk,      opt)
			vim.keymap.set('n', '<leader>hp', gs.preview_hunk,    opt)
			vim.keymap.set('n', '<leader>hb', gs.blame_line,      opt)
			vim.keymap.set('n', '<leader>hd', gs.diffthis,        opt)
		end,
	},
	{
		'isakbm/gitgraph.nvim',
		dependencies = { 'sindrets/diffview.nvim' },
		config = function()
			require('gitgraph').setup({})
			vim.keymap.set('n', '<leader>gg', function()
				require('gitgraph').draw({}, { all = true, max_count = 256 })
			end, { noremap = true, silent = true, desc = 'Git graph' })
		end,
	},
}

return M
