require 'configs.snippets'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

local lspkind = require 'lspkind'
lspkind.init {}

local cmp = require 'cmp'

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
  mapping = {
    -- why C-u does not work?
    ['<C-k>'] = cmp.mapping.scroll_docs(-8),
    ['<C-j>'] = cmp.mapping.scroll_docs(8),

    -- ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    -- ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    -- ['<C-y>'] = cmp.mapping(
    --   cmp.mapping.confirm {
    --     behavior = cmp.ConfirmBehavior.Insert,
    --     select = true,
    --   },
    --   { 'i', 'c' }
    -- ),

    ['<TAB>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<S-TAB>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
  },

  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
}

-- Setup up vim-dadbod
cmp.setup.filetype({ 'sql' }, {
  sources = {
    { name = 'vim-dadbod-completion' },
    { name = 'buffer' },
  },
})
