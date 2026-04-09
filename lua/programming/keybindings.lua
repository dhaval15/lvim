local M = {}

M.post = function ()
	local map = vim.keymap.set
	map("n", "gm", ":lua vim.lsp.buf.code_action()<CR>", opt)
	map("n", "gf", ":lua vim.lsp.buf.format()<CR>", opt)
	map("n", "gR", ":lua vim.lsp.buf.rename()<CR>", opt)

	-- info
	map("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opt)
	map("n", "gr", ":Telescope lsp_references<CR>", opt)
	map("n", "gi", ":Telescope lsp_incoming_calls<CR>", opt)
	map("n", "gI", ":Telescope lsp_implementations<CR>", opt)
	map("n", "gw", ":Telescope lsp_dynamic_workspace_symbols<CR>", opt)

	map("n", "gD", ":Telescope diagnostics<CR>", opt)
	map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opt)
end

return M
