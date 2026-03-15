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
    map("<leader>a", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("<leader>fo", function()
        vim.lsp.buf.format({ async = true })
    end, "[F]ormat")
end

---@diagnostic disable-next-line: lowercase-global
function custom_config(capabilities)
    local lsp_config = vim.lsp.config

    lsp_config["ocamllsp"] = {
        settings = {
            codelens = {
                enable = true,
                forNestedBindings = true,
            },
            duneDiagnostics = { enable = true },
            inlayHints = { enable = true },
            syntaxDocumentation = { enable = true },
        },
        cmd = { "ocamllsp" },
        capabilities = capabilities,
    }

    lsp_config["deno"] = {
        cmd = { "deno", "lsp" },
        root_dir = vim.fn.getcwd(),
        capabilities = capabilities,
    }

    lsp_config["rust_analyzer"] = {
        settings = {
            ["rust-analyzer"] = {
                codelens = { enabled = true },
                syntaxDocumentation = { enable = true },

                semanticTokenColorCustomizations = {
                    rules = {
                        ["*.mutable:rust"] = {
                            italic = true,
                        },
                        ["*.consuming:rust"] = {
                            italic = true,
                            underline = true,
                            foreground = "#83a598"
                        },
                        ["*.unsafe:rust"] = {
                            underline = true,
                            bold = true,
                        },
                    },
                },
                procMacro = {
                    ignored = {
                        leptos_macro = {
                            "server",
                        },
                    },
                },
            },
        },
        capabilities = capabilities,
    }

    lsp_config["clangd"] = {
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
        capabilities = capabilities,
    }
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            {
                "j-hui/fidget.nvim",
                opts = {},
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if not client then
                        return
                    end

                    if client:supports_method("TextDocument/Formatting", 0) then
                        vim.api.nvim_create_autocmd("BufWritePre", {
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

            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })

            require("mason-lspconfig").setup()

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local mason_lspconfig = require("mason-lspconfig")

            for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                })
            end

            custom_config(capabilities)
            local lsps = { "ocamllsp", "deno", "rust_analyzer" }
            vim.lsp.enable(lsps)

            vim.diagnostic.config({ virtual_text = true })
        end,
    },
    {
        "tarides/ocaml.nvim",
        config = function()
            require("ocaml").setup()
        end
    },
}
