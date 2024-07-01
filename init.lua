local g = vim.g
local k = vim.keycode
local opt = vim.opt
local opt_local = vim.opt_local
local set = vim.keymap.set

-- leader
g.mapleader = ' '

-- options
opt.inccommand = 'split'

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = 'yes'
opt.shada = { "'10", '<0', 's10', 'h' }

opt.clipboard = 'unnamedplus'

-- Don't have `o` add a comment
opt.formatoptions:remove 'o'

-- keymaps
set('i', 'jl', '<RIGHT>', { desc = 'Move one char Right' })
-- better alternatives
set('i', 'jk', '<ESC>', { desc = 'Better escape' })
set('n', 'U', '<CMD>redo<CR>', { desc = 'Better undo' })
set('n', ',', '@', { desc = 'Better macro' })
-- buffers
set('n', '<TAB>', '<CMD>bnext<CR>', { desc = 'Next buffer' })
set('n', '<S-TAB>', '<CMD>bprevious<CR>', { desc = 'Previous buffer' })
set('n', '<leader>c', '<CMD>bdelete<CR>', { desc = 'Delete buffer' })
set('n', '<leader>s', ':write<CR>', { desc = 'Write buffer' })
-- move through wrapped lines
set('n', 'j', 'gj')
set('n', 'k', 'gk')
-- split movement
set('n', '<c-j>', '<c-w><c-j>')
set('n', '<c-k>', '<c-w><c-k>')
set('n', '<c-l>', '<c-w><c-l>')
set('n', '<c-h>', '<c-w><c-h>')
-- execute line/file
set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'Execute the current line' })
set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })
-- Toggle highlight
set('n', '<leader>h', '<CMD>nohl<CR>', { desc = 'Remove search highlight' })

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
set('n', ']d', vim.diagnostic.goto_next)
set('n', '[d', vim.diagnostic.goto_prev)

-- These mappings control the size of splits (height/width)
set('n', '<M-.>', '<c-w>5<')
set('n', '<M-,>', '<c-w>5>')
set('n', '<M-t>', '<C-W>+')
set('n', '<M-s>', '<C-W>-')

set('n', '<M-j>', function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

set('n', '<M-k>', function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)

set('n', '<space>tt', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)

-- opt_local local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', {}),
  callback = function()
    opt_local.number = false
    opt_local.relativenumber = false
    opt_local.scrolloff = 0

    vim.bo.filetype = 'terminal'
  end,
})

-- Easily hit escape in terminal mode.
set('t', 'jk', '<c-\\><c-n>')

-- Open a terminal at the bottom of the screen with a fixed height.
set('n', '<leader>`', function()
  vim.cmd.new()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end)

-- lazy bootstrap
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/plugins/` folder
require('lazy').setup({ import = 'plugins' }, {
  change_detection = {
    notify = false,
  },
})
