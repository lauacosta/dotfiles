function SetLspKeymaps(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)

  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end

  map("<space>e", vim.diagnostic.open_float, "")
  map("K", vim.lsp.buf.hover, "[H]over")
  map("gS", vim.lsp.buf.signature_help, "[G]oto [S]ignature")
  map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd")
  map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove")
  map("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist")
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  map("<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "[F]ormat")

  if client.name == "omnisharp" then
    local omnisharp = require("omnisharp_extended")
    map("gd", omnisharp.lsp_definition, "[G]oto [D]efinition (OmniSharp)")
    map("gI", omnisharp.lsp_implementation, "[G]oto [I]mplementation (OmniSharp)")
    map("gr", omnisharp.lsp_references, "[G]oto [R]eferences (OmniSharp)")
    map("<leader>D", omnisharp.lsp_type_definition, "[D]efinition (OmniSharp)")
  else
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    map("<leader>D", vim.lsp.buf.type_definition, "[D]efinition")
  end
end

function Particular_config(capabilities)
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

  require "lspconfig".omnisharp.setup {
    settings = {
      codelens = {
        enabled = true,
        position = "above"
      },
      syntaxDocumentation = { enable = true },
      FormattingOptions = {
        EnableEditorConfigSupport = false
      },
      Formatting = false,
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
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
end

return { {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    { "Hoffs/omnisharp-extended-lsp.nvim" },
    {
      "j-hui/fidget.nvim",
      opts = {}
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        if client:supports_method('TextDocument/Formatting', 0) then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function()
              -- vim.lsp.buf.format({
              --   bufnr = event.buf,
              --   id = client.id
              -- })
              require("conform").format({ bufnr = event.buf })
            end,
          })
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

        SetLspKeymaps(event)
      end,
    })

    require("mason").setup()
    require("mason-lspconfig").setup()

    local capabilities = require "blink.cmp".get_lsp_capabilities()
    local mason_lspconfig = require "mason-lspconfig"

    mason_lspconfig.setup {
      automatic_enable = true,
    }
    for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
      vim.lsp.config(server_name, {
        capabilities = capabilities,
      })
    end

    Particular_config(capabilities)

    vim.diagnostic.config { virtual_text = true }
  end,
},
}
