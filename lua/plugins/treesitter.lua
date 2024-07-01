return {
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local configs = require 'nvim-treesitter.configs'

      configs.setup {
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'html', 'css', 'java' },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }
    end,
  },
}
