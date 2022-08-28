local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local utils = require "core.utils"

local function custom_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true

  local lsp_mappings = require("core.mappings").lspconfig
  utils.load_mappings({ lsp_mappings }, { buffer = bufnr })

  -- if client.server_capabilities.signatureHelpProvider then
  -- TODO
  -- end

  print(client.name .. " active")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

lspconfig.sumneko_lua.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

lspconfig.pyright.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

lspconfig.solargraph.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

lspconfig.html.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

lspconfig.tailwindcss.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

lspconfig.bashls.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}
