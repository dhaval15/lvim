local M = {}

M.plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		-- or branch = '0.1.x',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		config = function()
			require('telescope').setup{
				defaults = {
					file_ignore_patterns = {
						'**/node_modules/**',
					},
				},
				pickers = {
					find_files = {
						theme = 'ivy',
					},
				},
			}
			local opt = {
				noremap = true,
				silent = true,
			}
			local map = vim.keymap.set
			local builtin = require('telescope.builtin')
			-- Files
			map('n', '<leader>ee', builtin.find_files, opt)
			map('n', '<leader>e<Tab>', builtin.buffers, opt)
			map('n', '<leader>eg', builtin.git_files, opt)

			-- UI
			map('n', '<leader>uc', builtin.colorscheme, opt)

			-- Writing
			map('n', '<leader>ws', builtin.spell_suggest, opt)

			-- Lsp
			map('n', '<leader>le', builtin.diagnostics, opt)
			map('n', '<leader>lf', builtin.quickfix, opt)

			-- Others
			map('n', '<leader>fl', builtin.live_grep, opt)
			map('n', '<leader>ff', ':Telescope<CR>', opt)
			map('n', '<leader>fm', builtin.man_pages, opt)
		end,
	},
}

return M
