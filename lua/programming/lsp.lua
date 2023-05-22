local M = {}

M.plugins = {
	{
		'neovim/nvim-lspconfig',
		config = function()
			local lsp = require('lspconfig')
			lsp.lua_ls.setup {
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
			}
			local opt = {
				noremap = true,
				silent  = true,
			}
			local map = vim.keymap.set
			map("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opt)
			map("n", "gm", ":lua vim.lsp.buf.code_action()<CR>", opt)
			map("n", "gr", ":lua vim.lsp.buf.rename()<CR>", opt)
			map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opt)
			map("n", "gf", ":lua vim.lsp.buf.formatting()<CR>", opt)
			map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opt)
		end,
	},
}
return M
