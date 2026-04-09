local M = {}


M.plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		-- or branch = '0.1.x',
		dependencies = {
			{ 'nvim-lua/plenary.nvim', },
			{ 'MunifTanjim/nui.nvim', },
		},
		config = function()
			require('telescope').setup{
				defaults = {
					path_display = { "smart" },
					-- path_display = function(opts, path)
					-- 	local tail = require("telescope.utils").path_tail(path)
					-- 	return string.format("%s (%s)", tail, path)
					-- end,
					layout_config = {
						vertical = { 
							width = 0.99,
							height = 0.99,
							preview_cutoff = 120,
						},
						horizontal = {
							height = 0.99,
							preview_cutoff = 120,
							prompt_position = "bottom",
							width = 0.99,
						},
						-- other layout configuration here
					},
					-- other defaults configuration here
				},
				pickers = {
					find_files = {
						layout_strategy = 'bottom_pane',
						theme = 'ivy',
						prompt_title = false,
						prompt_prefix = 'Files> ',
						-- previewer = false,
						show_line = false,
						-- borderchars = {
						-- 		{ '─', '│', '─', '│', '┌', '┐', '┘', '└'},
						-- 		prompt = {"─", "│", "_", "│", '┌', '┐', "│", "│"},
						-- 		results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
						-- 		preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
						-- },
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
			map('n', '<leader>er', ':Telescope frecency workspace=CWD<CR>', opt)
			map('n', '<leader>eb', builtin.buffers, opt)
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
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension "frecency"
		end,
	},
	{
		'fannheyward/telescope-coc.nvim',
		config = function()
			require("telescope").load_extension("coc")
		end
	}
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
