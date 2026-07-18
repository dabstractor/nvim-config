return {
  -- (codeium.vim removed in Phase 4: replaced by minuet-ai.nvim on z.ai; see lua/plugins/minuet.lua)

  {
    'mg979/vim-visual-multi',
    branch = 'master',
    lazy = false,
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- (indent-blankline removed in Phase 2; mini.indentscope provides the guide line.)

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup {}
    end,
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        -- These map directly to tsserver's UserPreferences.
        tsserver_file_preferences = {
          -- Auto-import: accepting a completion for an export from another
          -- module makes tsserver emit the `import` statement via the LSP
          -- additionalTextEdits that blink.cmp applies on accept.
          includePackageJsonAutoImports = 'on',
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          -- Inlay hints (the display layer is toggled by vim.lsp.inlay_hint
          -- in lua/lsp.lua; tsserver must be asked to *produce* them here).
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionDeclarationTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- 'rcarriga/nvim-notify',
    },
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },

  'folke/flash.nvim',

  'folke/flash.nvim',

  'folke/zen-mode.nvim',

  'folke/twilight.nvim',

  'folke/snacks.nvim',

  'Mohammed-Taher/AdvancedNewFile.nvim',

  'mfussenegger/nvim-lua-debugger',

  -- 'junegunn/fzf.vim', -- removed Phase 2: legacy vimscript fzf wrapper, redundant with fzf-lua/telescope

  'tpope/vim-fugitive',

  'Rykka/lastbuf.vim',

  'vim-scripts/Rename2',

  'nvim-pack/nvim-spectre',

  'onsails/lspkind.nvim',

  'ThePrimeagen/refactoring.nvim',

  'JoseConseco/telescope_sessions_picker.nvim',

  'xiyaowong/nvim-transparent',

  'mbbill/undotree',

  'fabridamicelli/cronex.nvim',

  'smoka7/hop.nvim',

  'nvim-telescope/telescope-symbols.nvim',

  'ton/vim-bufsurf',

  'subnut/nvim-ghost.nvim',
}
