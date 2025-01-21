return {
  {
    'saghen/blink.cmp',
    dependencies = "rafamadriz/friendly-snippets",
    version = 'v0.*',
    opts = {
      keymap = { preset = 'default' },
      appeareance = {
        use_nvim_cpi_as_default = true,
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true }
    },
  },
}
