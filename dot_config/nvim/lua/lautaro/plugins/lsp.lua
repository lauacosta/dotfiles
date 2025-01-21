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
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    -- { "folke/neodev.nvim", opts = {} },
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        if client.supports_method('TextDocument/formatting', 0) then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function() vim.lsp.buf.format({ bufnr = event.buf, id = client.id }) end,
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
  end,
},
}
