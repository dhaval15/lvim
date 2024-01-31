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

-- Project Files
spy.search_project_files = function()
	local include_pattern = table.concat(spy.include_patterns or {}, '|')

	local fd_exclude_patterns = {}

  for _, exclude_pattern in ipairs(spy.exclude_patterns or {}) do
    table.insert(fd_exclude_patterns, '--exclude')
    table.insert(fd_exclude_patterns, exclude_pattern)
  end

	local find_command = {
    'fd',
    '--type',
    'f',
		include_pattern,
		unpack(fd_exclude_patterns),
  }

  require('telescope.builtin').find_files({
    prompt_title = 'Search Jsx',
    --cwd = vim.fn.expand('%:p:h'),  -- Start searching from the current directory
    find_command = find_command,  -- Use the find_command defined above
  })
end


M.post = function()
	local map = vim.keymap.set('n', '<leader>pe', spy.search_project_files, opt)
end

return M
