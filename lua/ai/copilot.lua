local M = {}

M.plugins = {
	{
		'github/copilot.vim',
	},
	{
		'CopilotC-Nvim/CopilotChat.nvim',
		dependencies = {
			'github/copilot.vim',
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('CopilotChat').setup({})

			local opt = { noremap = true, silent = true }
			local map = vim.keymap.set
			map('n', '<leader>cs', function() require('ai.claude_sessions').pick() end, opt)
			map('n', '<leader>cc', ':CopilotChat<CR>', opt)
			map('v', '<leader>cc', ':CopilotChat<CR>', opt)
			map('n', '<leader>ce', ':CopilotChatExplain<CR>', opt)
			map('v', '<leader>ce', ':CopilotChatExplain<CR>', opt)
			map('n', '<leader>cf', ':CopilotChatFix<CR>', opt)
			map('v', '<leader>cf', ':CopilotChatFix<CR>', opt)
		end,
	},
}

return M
