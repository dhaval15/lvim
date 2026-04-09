local M = {}

M.plugins = {
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
