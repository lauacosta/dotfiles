return {
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          ocaml = { "ocamlformat", lsp_format = "fallback" },
        },
      })
    end
  }
}
