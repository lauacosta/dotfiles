return {
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          ocaml = { "ocamlformat", lsp_format = "fallback" },
          rust = { "cargofmt", lsp_format = "fallback" },
          lua = { lsp_format = "fallback" },
          go = { "gofmt", lsp_format = "fallback" },
          yaml = { lsp_format = "fallback" },
        },
      })
    end
  }
}
