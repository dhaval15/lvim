local M = {}
M.pre = function ()
	vim.api.nvim_create_user_command('Sudow', function()
		vim.cmd [[w !sudo tee % >/dev/null]]
	end, { nargs = 0 })
end
return M
