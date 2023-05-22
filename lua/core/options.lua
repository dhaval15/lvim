local M = {}

M.pre = function()
	-- fonts
	vim.opt.encoding = 'utf8'
	vim.opt.guifont = 'Hack Nerd Font 11'

	-- visuals
	vim.opt.hlsearch = true
	vim.opt.mouse = 'a'
	vim.opt.cursorline = true
	vim.opt.termguicolors = true
	vim.opt.number = true

	-- identation
	vim.opt.shiftwidth = 2
	vim.opt.tabstop = 2

	-- undo
	-- vim.opt.undofile = true
	-- vim.opt.undodir= '/home/dhaval/.config/nvim/.undo/'

	-- wildmenu
	vim.opt.wildmenu = true
	-- vim.opt.wildmode = 'list:longest'

	-- comments
	-- tc: wrap text and comments using textwidth
	--  r: continue comments when pressing ENTER in I mode
	--  q: enable formatting of comments with gq
	--  n: detect lists for formatting
	--  b: auto-wrap in insert mode, and do not wrap old long lines
	vim.opt.formatoptions = 'tcrqnb'


	-- ' proper search
	-- set incsearch
	-- set ignorecase
	-- set smartcase
	-- set gdefault

	-- better splits
	vim.opt.splitbelow = true
	vim.opt.splitright = true
end

return M
