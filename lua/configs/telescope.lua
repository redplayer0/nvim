local actions = require 'telescope.actions'
local layout_actions = require 'telescope.actions.layout'

require('telescope').setup {
  pickers = {
    lsp_references = {
      -- line_width = 80,
      layout_strategy = 'vertical',
    },
    diagnostics = {
      line_width = 60,
      layout_strategy = 'vertical',
      layout_config = {
        preview_cutoff = 0,
      },
      previewer = require('telescope.previewers').new_buffer_previewer {
        title = 'Diagnostics',
        dyn_title = function(_, entry)
          return entry.title
        end,

        get_buffer_by_name = function(_, entry)
          return 'diagnostics_' .. tostring(entry.nr)
        end,

        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { entry.text })
        end,
      },
    },
  },
  defaults = {
    -- wrap_results = true,
    initial_mode = 'normal',
    path_display = { 'smart' },
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
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy find' })
vim.keymap.set('n', '<leader>gw', builtin.grep_string, { desc = 'Grep string' })
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fl', builtin.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'References' })
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Definitions' })
vim.keymap.set('n', '<leader>fv', function()
  builtin.git_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Nvim config files' })

vim.keymap.set('n', '<leader>gls', builtin.git_files, { desc = 'Git list files' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gh', builtin.git_stash, { desc = 'Git stash' })

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('telescope', {}),
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    vim.wo.wrap = true
  end,
})
