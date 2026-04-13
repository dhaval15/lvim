local M = {}

M.plugins = {
	{
		'akinsho/toggleterm.nvim',
		version = '*',
		dependencies = { 'ryanmsnyder/toggleterm-manager.nvim' },
		config = function()
			require('toggleterm').setup({
				size = function(term)
					if term.direction == 'horizontal' then return 15
					elseif term.direction == 'vertical' then return vim.o.columns * 0.4
					end
				end,
				shade_terminals = true,
				start_in_insert = true,
				persist_mode    = true,
				direction       = 'float',
				float_opts = {
					border   = 'curved',
					winblend = 5,
				},
			})

			local Terminal = require('toggleterm.terminal').Terminal
			local opt = { noremap = true, silent = true }

			require('toggleterm-manager').setup({
				results_title = 'Terminals',
				preview_title = 'Preview',
				mappings = {
					i = {
						['<CR>']  = { action = require('toggleterm-manager').actions.toggle_term, exit_on_action = true },
						['<C-d>'] = { action = require('toggleterm-manager').actions.delete_term, exit_on_action = false },
						['<C-n>'] = { action = require('toggleterm-manager').actions.create_term, exit_on_action = true },
					},
				},
			})

			-- Telescope picker
			vim.keymap.set('n', '<leader>tt', '<cmd>Telescope toggleterm_manager<CR>', opt)

			-- New fullscreen float terminal
			vim.keymap.set('n', '<leader>tn', function()
				local term = Terminal:new({
					direction = 'float',
					float_opts = {
						border = 'curved',
						width  = vim.o.columns,
						height = vim.o.lines - 2,
						row    = 0,
						col    = 0,
					},
					hidden = false,
				})
				term:toggle()
			end, opt)

			-- New terminal (horizontal split)
			vim.keymap.set('n', '<leader>th', function()
				local term = Terminal:new({ direction = 'horizontal', hidden = false })
				term:toggle()
			end, opt)

			-- Rename current terminal
			vim.keymap.set('n', '<leader>tr', function()
				local id = vim.b.toggle_number
				if not id then vim.notify('Not in a toggleterm buffer', vim.log.levels.WARN) return end
				local name = vim.fn.input('Rename terminal: ')
				if name ~= '' then
					require('toggleterm.terminal').get(id).display_name = name
				end
			end, opt)

			-- Bottom split (persistent build/run output)
			vim.keymap.set('n', '<leader>tj', '<cmd>ToggleTerm direction=horizontal<CR>', opt)

			-- Claude CLI (dedicated terminal)
			local claude = Terminal:new({
				cmd       = 'claude',
				direction = 'float',
				float_opts = { border = 'curved' },
				hidden    = true,
			})
			vim.keymap.set('n', '<leader>ta', function() claude:toggle() end, opt)

			-- Exit terminal insert mode to normal mode
			vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opt)

			-- In normal mode inside a toggleterm buffer, Esc minimizes it
			vim.api.nvim_create_autocmd('TermOpen', {
				pattern = 'term://*toggleterm*',
				callback = function()
					vim.keymap.set('n', '<Esc>', '<cmd>ToggleTerm<CR>', { buffer = true, silent = true })
				end,
			})
			vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', opt)
			vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', opt)
			vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', opt)
			vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', opt)
		end,
	},
}

return M
