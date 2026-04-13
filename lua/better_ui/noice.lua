local M = {}

M.plugins = {
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
		},
		config = function()
			require('noice').setup({
				lsp = {
					-- Use noice for LSP progress, hover, signature
					progress = { enabled = true },
					override = {
						['vim.lsp.util.convert_input_to_markdown_lines'] = true,
						['vim.lsp.util.stylize_markdown'] = true,
						['cmp.entry.get_documentation'] = true,
					},
					hover    = { enabled = true },
					signature = { enabled = true },
				},
				presets = {
					bottom_search         = true,  -- classic bottom search bar
					command_palette       = true,  -- floating cmdline + popupmenu
					long_message_to_split = true,  -- long messages go to split
					inc_rename            = false,
					lsp_doc_border        = true,  -- border on hover/signature docs
				},
				notify = {
					enabled = true,
				},
			})

			-- Dismiss notifications with <leader>nd
			vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', { noremap = true, silent = true })
		end,
	},
}

return M
