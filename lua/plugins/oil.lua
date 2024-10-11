return {
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        skip_confirm_for_simple_edits = true,
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-c>'] = 'actions.open_cwd',
          ['<M-h>'] = 'actions.select_split',
          ['_'] = 'actions.close',
        },
        view_options = {
          show_hidden = true,
        },
      }

      -- Open parent directory in current window
      vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

      -- Open parent directory in floating window
      -- vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
  },
}
