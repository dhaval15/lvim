local M = {}
M.pre = function ()
	vim.g.mapleader = ' '

	local opt = {
		noremap = true,
		silent = true,
	}
	local map = vim.api.nvim_set_keymap

	-- No ex mode please!
	map('n', 'Q', '<Nop>', opt)

	-- centered search
	map('n', 'n', 'nzz', opt)
	map('n', 'N', 'Nzz', opt)
	map('n', '*', '*zz', opt)
	map('n', '#', '#zz', opt)
	map('n', 'g*', 'g*zz', opt)

	-- buffer switching
	map('n', '<TAB>', ':bnext<CR>', opt)
	map('n', '<S-TAB>', ':bprevious<CR>', opt)

	-- no help
	map('','<F1>', '<Esc>', opt)
	map('i','<F1>', '<Esc>', opt)

	-- H/L
	map('n', 'H', '^', opt)
	map('n', 'L', '$', opt)
end
return M
