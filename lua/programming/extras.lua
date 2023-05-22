local get_master_node = function ()
	local ts_utils = require('nvim-treesitter.ts_utils')
	local node = ts_utils.get_node_at_cursor()
	if node == nil then
		error("No treesitter parser found")
	end

	local root = ts_utils.get_root_for_node(node)
	local start_row = node:start()
	local parent = node:parent()

	while parent ~= nil and parent ~= root and parent:start() == start_row do
		node = parent
		parent = node:parent()
	end
	return node
end

local select = function ()
	local ts_utils = require('nvim-treesitter.ts_utils')
	local node= get_master_node()
	local bufnum = vim.api.nvim_get_current_buf()
	ts_utils.update_selection(bufnum, node)
end

local delete = function ()
	local node= get_master_node()
	local bufnum = vim.api.nvim_get_current_buf()
	local start_row, start_col, end_row, end_col = node:range()
	vim.api.nvim_buf_set_text(bufnum, start_row, start_col, end_row, end_col, {' '})
end

local change = function ()
	M.delete()
	vim.cmd('startinsert')
end

local root = function ()
	local ts_utils = require('nvim-treesitter.ts_utils')
	local node = ts_utils.get_node_at_cursor()
	if node == nil then
		error("No treesitter parser found")
	end

	local start_row = node:start()
	local parent = node:parent()

	while parent ~= nil and parent:start() == start_row do
		node = parent
		parent = node:parent()
	end
end

local M = {}

M.post = function ()
	vim.api.nvim_create_user_command('Test', root, { nargs = 0 })
end

return M
