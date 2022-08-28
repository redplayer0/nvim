vim.cmd "packadd packer.nvim"

local plugins = {

  ["nvim-lua/plenary.nvim"] = { module = "plenary" },
  ["wbthomason/packer.nvim"] = {},

  ["EdenEast/nightfox.nvim"] = {
    tag = "v1.0.0",
  },

  ["kyazdani42/nvim-web-devicons"] = {
    module = "nvim-web-devicons",
    config = function()
      require("plugins.configs.others").devicons()
    end,
  },

  ["romgrk/barbar.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "barbar.nvim"
    end,
    config = function()
      require("plugins.configs.barbar")
    end,
  },

  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "indent-blankline.nvim"
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- git stuff
  ["lewis6991/gitsigns.nvim"] = {
    ft = "gitcommit",
    setup = function()
      require("core.lazy_load").gitsigns()
    end,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },

  -- lsp stuff

  -- ["williamboman/nvim-lsp-installer"] = {
  --    opt = true,
  --    cmd = require("core.lazy_load").lsp_cmds,
  --    setup = function()
  --       require("core.lazy_load").on_file_open "nvim-lsp-installer"
  --    end,
  -- },

  ["neovim/nvim-lspconfig"] = {
    -- module = "lspconfig",
    -- cmd = require("core.lazy_load").lsp_cmds,
    -- setup = function()
    --    require("core.lazy_load").on_file_open "nvim-lspconfig"
    -- end,
    config = function()
      -- require "plugins.configs.lsp_installer"
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only

  ["rafamadriz/friendly-snippets"] = {
    module = "cmp_nvim_lsp",
    event = "InsertEnter",
  },

  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").luasnip()
    end,
  },

  ["saadparwaiz1/cmp_luasnip"] = {
    after = "LuaSnip",
  },

  ["hrsh7th/cmp-nvim-lua"] = {
    after = "cmp_luasnip",
  },

  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "cmp-nvim-lua",
  },

  ["hrsh7th/cmp-buffer"] = {
    after = "cmp-nvim-lsp",
  },

  ["hrsh7th/cmp-path"] = {
    after = "cmp-buffer",
  },

  -- misc plugins
  ["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").autopairs()
    end,
  },

  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
  },

  -- file managing , picker etc
  ["kyazdani42/nvim-tree.lua"] = {
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require "plugins.configs.nvimtree"
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = function()
      require "plugins.configs.telescope"
    end,
  },

  -- Only load whichkey after all the gui
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function()
      require "plugins.configs.whichkey"
    end,
  },

  -- Rails specific
  ["tpope/vim-rails"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").rails()
    end,
    config = function()
      require("plugins.configs.others").rails()
    end,
  }
}

require("core.packer").run(plugins)
