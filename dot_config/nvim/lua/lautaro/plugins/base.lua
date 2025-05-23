local import = function(libraries)
  local libs = {}
  for _, lib in ipairs(libraries) do
    table.insert(libs, { lib, enabled = true, event = "VeryLazy" })
  end
  return libs
end

return {
  { "tpope/vim-fugitive",          enabled = true, event = "VeryLazy" },
  { "f-person/git-blame.nvim",     enabled = true, event = "VeryLazy" },
  { "windwp/nvim-ts-autotag",      enabled = true, event = "VeryLazy" },
  { "tpope/vim-commentary",        enabled = true, event = "VeryLazy" },
  { "mfussenegger/nvim-jdtls",     enabled = true, event = "VeryLazy" },
  { "nvim-tree/nvim-web-devicons", enabled = true, event = "VeryLazy" },
  { "kshenoy/vim-signature" },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  -- {
  --   "lewis6991/hover.nvim",
  --   config = function()
  --     require("hover").setup {
  --       init = function()
  --         -- Require providers
  --         require("hover.providers.lsp")
  --         -- require('hover.providers.gh')
  --         -- require('hover.providers.gh_user')
  --         -- require('hover.providers.jira')
  --         -- require('hover.providers.dap')
  --         -- require('hover.providers.fold_preview')
  --         -- require('hover.providers.diagnostic')
  --         -- require('hover.providers.man')
  --         -- require('hover.providers.dictionary')
  --         -- require('hover.providers.highlight')
  --       end,
  --       preview_opts = {
  --         border = 'single'
  --       },
  --       -- Whether the contents of a currently open hover window should be moved
  --       -- to a :h preview-window when pressing the hover keymap.
  --       preview_window = false,
  --       title = true,
  --       mouse_providers = {
  --         'LSP'
  --       },
  --       mouse_delay = 1000
  --     }

  --     -- Setup keymaps
  --     vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
  --     vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
  --     vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end,
  --       { desc = "hover.nvim (previous source)" })
  --     vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end,
  --       { desc = "hover.nvim (next source)" })

  --     -- Mouse support
  --     vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
  --     vim.o.mousemoveevent = true
  --   end
  -- },

  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = true,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        overrides = {
          Comment = { fg = "#fe8019" },
          LspInlayHint = { fg = "#928374", italic = true },
          FidgetTitle = { fg = "#fabd2f", bold = true },
          FidgetTask = { fg = "#b8bb26" },
        },
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "echasnovski/mini.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = true })
    end,
  },
}
