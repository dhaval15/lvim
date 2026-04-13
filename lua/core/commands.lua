local M = {}
M.pre = function ()
	vim.api.nvim_create_user_command('Sudow', function()
		vim.cmd [[w !sudo tee % >/dev/null]]
	end, { nargs = 0 })

	-- :q deletes buffer instead of quitting
	vim.cmd('cnoreabbrev q bd')
end
return M
