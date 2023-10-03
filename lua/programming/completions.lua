local M = {}

M.plugins = {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				tag = 'v1.2.1.*',
				build = 'make install_jsregexp',
			},
			{
				'hrsh7th/cmp-nvim-lsp',
			}
		},
		config = function() 
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' }, -- For luasnip users.
				}, {
					{ name = 'buffer' },
				})
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = 'buffer' },
				})
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline(':', {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = cmp.config.sources({
			-- 		{ name = 'path' }
			-- 	}, {
			-- 		{ name = 'cmdline' }
			-- 	})
			-- })

			-- Set up lspconfig.
			local lsp = require('lspconfig')
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local servers = {
				'dartls',
				'pyright',
				'tsserver',
				'gopls',
				'rust_analyzer',
				'kotlin_language_server',
				'sqlls',
			}
			for _,v in pairs(servers) do
				lsp[v].setup {
					capabilities = capabilities
				}
			end

			--- Only for css and html
			local extras = {
				'cssls',
				'html',
			}
			local e_capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			for _,v in pairs(extras) do
				lsp[v].setup {
					capabilities = e_capabilities
				}
			end
		end,
	},
}
return M
