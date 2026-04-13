local M = {}

M.plugins = {
	{
		'folke/zen-mode.nvim',
		cmd = 'ZenMode',
		config = function()
			require('zen-mode').setup({
				window = {
					backdrop = 1,
					width    = 0.6,
					height   = 1,
					options  = {
						signcolumn      = 'no',
						number          = false,
						relativenumber  = false,
						cursorline      = false,
						cursorcolumn    = false,
						colorcolumn     = '',
						foldcolumn      = '0',
						list            = false,
					},
				},
				plugins = {
					twilight   = { enabled = true },
					gitsigns   = { enabled = false },
					tmux       = { enabled = false },
					todo_comments = { enabled = false },
				},
				on_open = function()
					vim.opt.laststatus  = 0
					vim.opt.showtabline = 0
					vim.opt.cmdheight   = 0
					-- hide kitty tab bar by setting min tabs impossibly high
					vim.fn.jobstart('kitty @ set-option tab_bar_min_tabs=9999')
				end,
				on_close = function()
					vim.opt.laststatus  = 2
					vim.opt.showtabline = 1
					vim.opt.cmdheight   = 1
					-- restore kitty tab bar
					vim.fn.jobstart('kitty @ set-option tab_bar_min_tabs=2')
				end,
			})
			vim.keymap.set('n', '<leader>mz', '<cmd>ZenMode<CR>',
				{ noremap = true, silent = true, desc = 'Toggle Zen Mode' })
		end,
	},
	{
		'folke/twilight.nvim',
		cmd = 'Twilight',
		config = function()
			require('twilight').setup({
				dimming = { alpha = 0.25 },
				context = 10,
			})
		end,
	},
	{
		'preservim/vim-pencil',
		ft = { 'markdown', 'text', 'tex' },
		config = function()
			vim.g['pencil#wrapModeDefault'] = 'soft'
			vim.g['pencil#conceallevel'] = 0

			-- auto-enable for writing filetypes
			vim.api.nvim_create_autocmd('FileType', {
				pattern = { 'markdown', 'text', 'tex' },
				callback = function() vim.fn['pencil#init']() end,
			})

			local opt = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>ms', '<cmd>SoftPencil<CR>', opt)
			vim.keymap.set('n', '<leader>mh', '<cmd>HardPencil<CR>', opt)
			vim.keymap.set('n', '<leader>mp', '<cmd>TogglePencil<CR>', opt)
		end,
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-tree/nvim-web-devicons',
		},
		ft = { 'markdown' },
		config = function()
			require('render-markdown').setup({
				heading = {
					enabled = true,
					sign    = false,
					icons   = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
				},
				code = {
					enabled   = true,
					sign      = false,
					style     = 'full',
					border    = 'thin',
				},
				bullet = {
					enabled = true,
					icons   = { '●', '○', '◆', '◇' },
				},
				checkbox = {
					enabled   = true,
					unchecked = { icon = '☐' },
					checked   = { icon = '☑' },
				},
				table = {
					enabled = true,
					style   = 'full',
				},
				link = {
					enabled = true,
				},
			})

			local opt = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<CR>', opt)
		end,
	},
}

return M
