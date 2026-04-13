local M = {}

M.plugins = {
	{
		'neovim/nvim-lspconfig',
		config = function()
			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
						},
						diagnostics = {
							globals = {'vim'},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			vim.lsp.enable('lua_ls')
			local opt = {
				noremap = true,
				silent  = true,
			}
			local map = vim.keymap.set
			-- actions
			map("n", "K", ':lua vim.lsp.buf.hover()<CR>', {silent = true})
			map("n", "gf", ":lua vim.lsp.buf.format()<CR>", opt)
			map("n", "gR", ":lua vim.lsp.buf.rename()<CR>", opt)

			-- info
			map("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opt)
			map("n", "gr", ":Telescope lsp_references<CR>", opt)
			map("n", "gi", ":Telescope lsp_incoming_calls<CR>", opt)
			map("n", "gI", ":Telescope lsp_implementations<CR>", opt)
			map("n", "gw", ":Telescope lsp_dynamic_workspace_symbols<CR>", opt)
			map("n", "gs", ":Telescope lsp_dynamic_workspace_symbols<CR>", opt)
			map("n", "gh", ":Telescope lsp_incoming_calls<CR>", opt)

			map("n", "gD", ":Telescope diagnostics<CR>", opt)
			map("n", "ge", ":Telescope diagnostics<CR>", opt)
			map("n", "go", ":Telescope lsp_document_symbols<CR>", opt)
		end,
	},
}
return M
