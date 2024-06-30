return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require 'telescope.actions'
      local layout_actions = require 'telescope.actions.layout'
      require('telescope').setup {
        defaults = {
          wrap_results = true,
          mappings = {
            i = {
              ['<ESC>'] = actions.close,
            },
            n = {
              ['p'] = layout_actions.toggle_preview,
              ['K'] = actions.preview_scrolling_up,
              ['J'] = actions.preview_scrolling_down,
              ['<ESC>'] = actions.close,
              ['q'] = actions.close,
            },
          },
        },
      }

      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>o', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>ft', builtin.git_files, { desc = 'Find git files' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy find' })
      vim.keymap.set('n', '<leader>gw', builtin.grep_string, { desc = 'Grep string' })

      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = 'Document symbols' })
      vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
      vim.keymap.set('n', '<leader>fd', function()
        builtin.diagnostics {
          -- no_sign = true,
          line_width = 80,
        }
      end, { desc = 'Diagnostics' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'References' })
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Definitions' })

      vim.keymap.set('n', '<leader>fv', function()
        builtin.git_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Nvim config files' })

      vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup('telescope', {}),
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          vim.wo.wrap = true
        end,
      })
    end,
  },
}
