return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/neodev.nvim',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

      -- Autoformatting
      'stevearc/conform.nvim',

      -- Schema information
      'b0o/SchemaStore.nvim',
      'nvim-java/nvim-java',
    },
    config = function()
      require('java').setup()

      require('neodev').setup {
        -- library = {
        --   plugins = { "nvim-dap-ui" },
        --   types = true,
        -- },
      }

      local capabilities = nil
      if pcall(require, 'cmp_nvim_lsp') then
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      end

      local lspconfig = require 'lspconfig'

      local servers = {
        bashls = true,
        pylsp = true,

        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },

        -- Probably want to disable formatting for this lang server
        tsserver = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == 'table' then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require('mason').setup()
      local ensure_installed = {
        'isort',
        'black',
        'stylua',
        'lua_ls',
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      lspconfig.jdtls.setup {
        capabilities = capabilities,
      }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend('force', {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

          local settings = servers[client.name]
          if type(settings) ~= 'table' then
            settings = {}
          end

          local builtin = require 'telescope.builtin'

          vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = 0, desc = 'Open float diagnostic' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = 0, desc = 'Declaration' })
          vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = 0, desc = 'Type definition' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0, desc = 'Hover' })

          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = 0, desc = 'Lsp rename' })
          vim.keymap.set('n', '<space>ga', vim.lsp.buf.code_action, { buffer = 0, desc = 'Code actions' })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      local diagnostics = {
        virtual_text = false,
        virtual_improved = {
          current_line = 'only',
        },
      }
      vim.diagnostic.config(diagnostics)

      -- Autoformatting Setup
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
        },
      }

      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(args)
          require('conform').format {
            bufnr = args.buf,
            lsp_fallback = true,
            quiet = true,
          }
        end,
      })
    end,
  },
}
