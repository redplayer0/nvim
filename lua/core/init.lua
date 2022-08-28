-- commands

-- autocmds
local autocmd = vim.api.nvim_create_autocmd
local api = vim.api

-- Restore cursor
autocmd("BufRead", {
  pattern = { "*" },
  command = [[ call setpos(".", getpos("'\"")) ]]
})

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- wrap the PackerSync command to warn people before using it in NvChadSnapshots
-- autocmd("VimEnter", {
--    callback = function()
--       vim.cmd "command! -nargs=* -complete=customlist,v:lua.require'packer'.plugin_complete PackerSync lua require('core.utils').packer_sync(<f-args>)"
--    end,
-- })

-- Disable statusline in dashboard
autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.opt.laststatus = 0
  end,
})

autocmd("BufUnload", {
  buffer = 0,
  callback = function()
    vim.opt.laststatus = 3
  end,
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- store listed buffers in tab local var
vim.t.bufs = vim.api.nvim_list_bufs()

-- Filetype specific
autocmd("BufEnter", {
  pattern = "*.asm",
  callback = function()
    vim.opt.tabstop = 8
    vim.opt.shiftwidth = 8
    vim.opt.expandtab = false
  end,
})

-- Terminal stuff
autocmd("TermOpen", {
  pattern = { "*" },
  command = "setlocal nonumber norelativenumber"
})

autocmd("TermOpen", {
  pattern = { "*" },
  command = "startinsert"
})
