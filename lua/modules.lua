local lazypath = vim.fn.stdpath("data") .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {}
local pre = {}
local post = {}

local M = {}

M.add = function(module)
	table.insert(plugins, module)
end

local load = function (module)
	if module.plugins then
		for _, plugin in ipairs(module.plugins) do
			table.insert(plugins, plugin)
		end
	end
	if module.pre then
		table.insert(pre, module.pre)
	end
	if module.post then
		table.insert(post, module.post)
	end
end

M.init = function(config)
	for key1, value1 in pairs(config) do
		if type(value1) == 'table' then
			for key2, value2 in pairs(value1) do
				if value2 == true then
					local path = key1 .. '.' .. key2
					local module = require(path)
					if module then
						load(module)
					end
				end
			end
		elseif value1 then
			require(key1)
		end
	end
	for _, fn in pairs(pre) do
		fn()
	end
	require('lazy').setup(plugins)
	for _, fn in pairs(post) do
		fn()
	end
end

return M
