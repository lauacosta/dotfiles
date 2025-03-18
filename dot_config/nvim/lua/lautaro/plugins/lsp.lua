return { {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      opts = {
        library = {
          { path = "${3d}/luv/library", words = { "vim%.uv" } },
        }
      }
    },
    "SmiteshP/nvim-navic",
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    { "j-hui/fidget.nvim",                           opts = {} },
  },
  config = function()
    local navic = require("nvim-navic")

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, event.buf)
        end

        if client.supports_method('TextDocument/Formatting', 0) then
          if client.name ~= 'pylsp' or client.name ~= 'ts_ls' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = event.buf,
                  id = client.id
                })
              end,
            })
          end
        end

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


        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<space>e", vim.diagnostic.open_float, "")
        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("K", vim.lsp.buf.hover, "[H]over")
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
      end,
    })

    require("mason").setup()
    require("mason-lspconfig").setup()

    local capabilities = require "blink.cmp".get_lsp_capabilities()
    require "mason-lspconfig".setup_handlers {
      function(server_name)
        require "lspconfig"[server_name].setup { capatabilites = capabilities }
      end
    }
    require "lspconfig".ocamllsp.setup {
      settings = {
        codelens = {
          enabled = true,
          position = "above"
        },
        syntaxDocumentation = { enable = true },
      },
      capabilities = capabilities
    }

    require "lspconfig".pylsp.setup {
      settings = {
        codelens = {
          enabled = true,
          position = "above"
        },
        syntaxDocumentation = { enable = true },
      },
      capabilities = capabilities
    }

    require "lspconfig".rust_analyzer.setup {
      settings = {
        codelens = { enabled = true },
        syntaxDocumentation = { enable = true },
        ["rust-analyzer"] = {
          procMacro = {
            ignored = {
              leptos_macro = {
                -- optional: --
                -- "component",
                "server",
              },
            },
          },
        },
      },
      capabilities = capabilities
    }

    require "lspconfig".phpactor.setup {
      init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false, },

      capabilities = capabilities
    }

    require "lspconfig".clangd.setup {
      settings = {
        codelens = { enabled = true },
        syntaxDocumentation = { enable = true },
      },
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      capabilities = capabilities
    }


    -- require("lsp_lines").setup()
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end,
},
}
