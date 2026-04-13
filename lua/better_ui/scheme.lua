local M = {}

M.plugins = {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		config = function()
			require('rose-pine').setup({
				dark_variant = 'moon',
				styles = {
					bold   = true,
					italic = true,
					transparency = false,
				},
			})

			local function apply_theme(mode)
				if mode == 'dark' then
					vim.o.background = 'dark'
					vim.cmd('colorscheme rose-pine-moon')
					vim.api.nvim_set_hl(0, 'Normal',     { bg = '#232136' })
					vim.api.nvim_set_hl(0, 'NormalNC',   { bg = '#232136' })
					vim.api.nvim_set_hl(0, 'NormalFloat',{ bg = '#1a1825' })
					vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#232136' })
					vim.api.nvim_set_hl(0, 'EndOfBuffer',{ bg = '#232136' })
				else
					vim.o.background = 'light'
					vim.cmd('colorscheme rose-pine-dawn')
				end
			end

			local function detect_system_theme()
				local result = vim.fn.system('defaults read -g AppleInterfaceStyle 2>/dev/null')
				if result:find('Dark') then return 'dark' else return 'light' end
			end

			apply_theme(detect_system_theme())

			-- Auto-switch when macOS appearance changes
			vim.api.nvim_create_autocmd('Signal', {
				callback = function()
					apply_theme(detect_system_theme())
				end,
			})

			-- Manual toggle
			vim.keymap.set('n', '<leader>ut', function()
				local mode = vim.o.background == 'dark' and 'light' or 'dark'
				apply_theme(mode)
			end, { noremap = true, silent = true, desc = 'Toggle theme' })
		end,
	},
}

return M
