return {
    {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    ocaml = { "ocamlformat", lsp_format = "fallback" },
                    rust = { "cargofmt", lsp_format = "fallback" },
                    lua = { "stylua", lsp_format = "fallback" },
                    json = { "biome", lsp_format = "fallback" },
                    go = { "gofmt", lsp_format = "fallback" },
                    yaml = { lsp_format = "fallback" },
                    typescript = { "biome", lsp_format = "fallback" },
                    javascript = { "biome", lsp_format = "fallback" },
                    html = { "prettier", lsp_format = "fallback" },
                    svelte = { "biome", lsp_format = "fallback" },
                    python = { "ruff", lsp_format = "fallback" },
                },
            })
        end,
    },
}
