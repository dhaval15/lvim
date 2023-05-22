local function config()
end

local function build()
end

local function install()
end

local function find_from_project()
	local current_dir = vim.fn.getcwd()
	vim.cmd('Easypick spy_list')
	vim.cmd('Telescope find_files')
	vim.cmd('cd ' .. current_dir)
end

local function reload()
	vim.cmd('luafile .spy.lua')
end

local opt = {
	noremap = true,
	silent  = true,
}

local M = {}

M.post = function ()
	local map = vim.keymap.set
	map('n', '<leader>pl', ':Easypick spy_list<CR>', opt)
	map('n', '<leader>pc', config, opt)
	map('n', '<leader>pb', build, opt)
	map('n', '<leader>pi', install, opt)
	map('n', '<leader>pr', reload, opt)
	map('n', '<leader>pp', ':Easypick spy_actions<CR>', opt)
	map('n', '<leader>pf', find_from_project, opt)
end

return M
