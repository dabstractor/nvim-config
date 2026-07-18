return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- `lazydev` configures LuaLS for editing your Neovim config, runtime and plugins
    -- (replaces the end-of-life neodev.nvim). Configured automatically via opts.
    { 'folke/lazydev.nvim', opts = {} },
    { 'Saghen/blink.cmp' }, -- loads before lsp config so capabilities resolve
  },
  config = function()
    -- Runs when an LSP attaches to a buffer. Buffer-local keymaps + reference highlight.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>uh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
        end, 'Toggle Inlay [H]ints')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references of the word under the cursor when it rests.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- Capabilities: nvim-cmp for now (Phase 4 swaps in blink.cmp).
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
    -- Apply capabilities to EVERY server config (the '*' wildcard).
    vim.lsp.config('*', { capabilities = capabilities })

    -- Inlay hints: show inline type/parameter hints for servers that support
    -- them (e.g. tsserver via typescript-tools.nvim, whose tsserver_file_preferences
    -- are configured in lua/plugins/init.lua). Toggle per-buffer with <leader>uh.
    vim.lsp.inlay_hint.enable(true)

    -- Per-server overrides. Servers not listed here use the defaults shipped by
    -- nvim-lspconfig (lsp/<name>.lua). This replaces the old mason-lspconfig
    -- handler dance; we now use the native Neovim 0.11+ vim.lsp.config / vim.lsp.enable API.
    local servers = {
      gopls = {},
      pyright = {},
      rust_analyzer = {},
      phpactor = {},
      openscad_lsp = {},
      -- ESLint LSP: live lint diagnostics + code actions (autofix / "fix all").
      -- ESLint 10 flat config (eslint.config.js) is auto-detected by recent
      -- eslint-lsp. Prettier (via conform) remains the sole formatter; your
      -- eslint.config.js applies eslint-config-prettier last, so the two never
      -- conflict. If diagnostics don't show up, uncomment the experimental line.
      eslint = {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        -- settings = { experimental = { useFlatConfig = true } },
      },
      -- NOTE: TypeScript is handled by `pmizio/typescript-tools.nvim` (see
      -- lua/plugins/init.lua), NOT by ts_ls here. We intentionally do NOT add
      -- `ts_ls` -- having both servers attached to .ts/.tsx causes duplicated
      -- diagnostics, hover, and conflicting format providers.
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      -- YAML: schemas for k8s / github actions / docker-compose. (Inlined from
      -- the old lua/lsp/yaml.lua; root_dir fn -> native root_markers list.)
      yamlls = {
        root_markers = { '.git', '.yamllint', 'yamlfmt.yaml' },
        settings = {
          yaml = {
            schemas = {
              kubernetes = '/*.yaml',
              ['https://schemastore.org/github-action.json'] = '/.github/workflows/*.yml',
              ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
            },
            validate = true,
            format = { enable = true },
            completion = true,
          },
        },
      },
    }

    -- Register only the non-empty overrides (empty tables rely on lspconfig defaults),
    -- then enable every server. Neovim starts each on its matching filetypes.
    for name, cfg in pairs(servers) do
      if cfg and next(cfg) ~= nil then
        vim.lsp.config(name, cfg)
      end
    end
    vim.lsp.enable(vim.tbl_keys(servers))

    -- Mason: install servers + tools (installation only; enabling is native above).
    require('mason').setup()
    require('mason-lspconfig').setup { automatic_enable = false }

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'yamlfmt',
      -- JS/TS toolchain (used by conform.nvim for format-on-save)
      'prettierd',
      'prettier',
      -- JS/TS linter (LSP) -- see the `eslint` server above
      'eslint-lsp',
      -- Markdown linter (used by nvim-lint; see lua/kickstart/plugins/lint.lua)
      'markdownlint',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  end,
}
