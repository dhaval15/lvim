local M = {}

M.plugins = {
	{
		'Chaitanyabsprip/fastaction.nvim',
		config = function()
			require('fastaction').setup({
				dismiss_keys = { 'j', 'k', '<c-c>', 'q' },
				popup = { border = 'rounded' },
			})
			local opt = { noremap = true, silent = true }
			vim.keymap.set('n', 'gm', function() require('fastaction').code_action() end, opt)
			vim.keymap.set('v', 'gm', function() require('fastaction').range_code_action() end, opt)
		end,
	},
	{
		'nvimdev/lspsaga.nvim',
		event = 'LspAttach',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			require('lspsaga').setup({
				ui = {
					border        = 'curved',
					code_action   = '💡',
				},
				lightbulb = {
					enable        = true,
					sign          = true,
					virtual_text  = false,
				},
				outline = {
					layout        = 'float',
					close_after_jump = true,
				},
				breadcrumbs = {
					enable        = true,
				},
			})

			local opt = { noremap = true, silent = true }
			-- Replace basic LSP bindings with lspsaga enhanced versions
			vim.keymap.set('n', 'K',          '<cmd>Lspsaga hover_doc<CR>',        opt)
			vim.keymap.set('n', 'gR',         '<cmd>Lspsaga rename<CR>',           opt)
			vim.keymap.set('n', 'gd',         '<cmd>Lspsaga peek_definition<CR>',  opt)
			vim.keymap.set('n', 'gD',         '<cmd>Lspsaga goto_definition<CR>',  opt)
			vim.keymap.set('n', '<leader>go', '<cmd>Lspsaga outline<CR>',          opt)
			vim.keymap.set('n', ']e',         '<cmd>Lspsaga diagnostic_jump_next<CR>', opt)
			vim.keymap.set('n', '[e',         '<cmd>Lspsaga diagnostic_jump_prev<CR>', opt)
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>go", "<cmd>Outline<CR>",
				{ desc = "Toggle Outline" })

			require("outline").setup {
				-- Your setup opts here (leave empty to use defaults)
			}
		end,
	},
	{
		'mistricky/codesnap.nvim',
		build = 'make',
		cmd = { 'CodeSnap', 'CodeSnapSave' },
		config = function()
			require('codesnap').setup({
				save_path        = '~/Desktop/',
				has_breadcrumbs  = true,
				bg_theme         = 'grape',
				watermark        = '',
			})
		end,
	},
	{
		'bassamsdata/namu.nvim',
		config = function()
			require('namu').setup({
				namu_symbols = {
					enable  = true,
					options = {
						row_position = 'top10_right',
						right_position = {
							fixed = true,
							ratio = 0.6,
						},
					},
				},
			})
			local opt = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>ss', '<cmd>Namu symbols<CR>', opt)
		end,
	},
	{
	 	"folke/trouble.nvim",
	 	dependencies = { "nvim-tree/nvim-web-devicons" },
	 	opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	-- {
	-- 	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	-- 	config = function()
	-- 		require("lsp_lines").setup()
	-- 		vim.diagnostic.config({
 --  			virtual_text = false,
	-- 			virtual_lines = { 
	-- 				only_current_line = true,
	-- 				highlight_whole_line = false,
	-- 			},
	-- 		})
	-- 		local map = vim.keymap.set
	-- 		-- actions
	-- 		map("n", "<leader>gl", ":lua require('lsp_lines').toggle()<CR>", opt)
	-- 	end,
	-- },
}

return M
