return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/lazydev.nvim", opts = {} },
		},
		opts = {
			inlay_hints = { enabled = true },
			code_lens = { enable = true },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<space>e", vim.diagnostic.open_float, "")
					map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					map("H", vim.lsp.buf.hover, "[H]over")
					map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
					map("gS", vim.lsp.buf.signature_help, "[G]oto [S]ignature")
					map("gr", vim.lsp.buf.references, "[G]oto [R]erences")
					map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd")
					map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove")
					map("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist")
					map("<leader>D", vim.lsp.buf.type_definition, "[D]efinition")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, "[F]ormat")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave", "BufEnter" }, {
				group = vim.api.nvim_create_augroup("LspCodelens", { clear = true }),
				callback = function()
					vim.lsp.codelens.refresh({ bufnr = 0 })
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				clangd = {},
				-- tsserver = {
				-- 	settings = {
				-- 		typescript = {
				-- 			inlayHints = {
				-- 				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
				-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				-- 				includeInlayVariableTypeHints = true,
				-- 				includeInlayFunctionParameterTypeHints = true,
				-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				-- 				includeInlayPropertyDeclarationTypeHints = true,
				-- 				includeInlayFunctionLikeReturnTypeHints = true,
				-- 				includeInlayEnumMemberValueHints = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
				gopls = {
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				rust_analyzer = {},
				ocamllsp = {
					settings = {
						codelens = { enable = true },
						inlayHints = { enable = true },
						syntaxDocumentation = { enable = true },
						extendedHover = { enable = true },
					},

					server_capabilities = { semanticTokensProvider = false },
				},
				ruff_lsp = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"biome",
				"sqlfmt",
				"goimports",
				"beautysh",
				"ruff",
				"ocamlformat",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
							require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
