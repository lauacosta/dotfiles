require("lautaro.set")
require("lautaro.lazy")
require("lautaro.keymaps")
require("lspconfig").phpactor.setup({})
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = "/home/lautaro/.local/share/nvim/mason/bin/vue-language-server",
				languages = { "vue" },
			},
		},
	},
})

lspconfig.volar.setup({
	init_options = {
		vue = {
			hybridMode = false,
		},
	},
})
