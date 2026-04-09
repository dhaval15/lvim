local M = {}

M.plugins = {
	{
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
			-- alternatively you can override the default configs
			require("flutter-tools").setup {
				fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
				widget_guides = {
					enabled = true,
  			},
				dev_log = {
					enabled = true,
					notify_errors = false, -- if there is an error whilst running then notify the user
					open_cmd = "edit", -- command to use to open the log buffer
				},
				outline = {
					open_cmd = "30vnew", -- command to use to open the outline buffer
					auto_open = false -- if true this will open the outline automatically when it is first populated
  			},
			}
			local map = vim.keymap.set
			map("n", "<leader>gt", ":FlutterOutlineToggle<CR>", opt)
		end,
	},
}

return M
