local M = {}

M.plugins = {
	{
		'nvim-treesitter/nvim-treesitter',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = {
					'dart',
					'lua',
					'python',
					'org',
				},
				sync_install = false,
				rainbow = {
					enable = true,
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { 'org' },
				},
			}
		end,
	},
}

return M
