return {
  {
    'echasnovski/mini.nvim',
    lazy = true,
    event = 'BufEnter',
    config = function()
      -- clue configuration
      local miniclue = require 'mini.clue'
      miniclue.setup {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          config = { width = 60 },
          delay = 100,
        },
      }

      require('mini.ai').setup()
      require('mini.jump').setup()
      require('mini.jump2d').setup {
        labels = 'asdfghjklcneivm',
        view = {
          n_steps_ahead = 1,
        },
        allowed_lines = {
          blank = false,
          cursor_at = false,
        },
      }
      vim.keymap.set(
        'n',
        '<CR>',
        '<CMD>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>',
        { desc = 'Jump to word' }
      )
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.tabline').setup()
    end,
  },
}
