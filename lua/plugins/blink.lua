return {
  -- blink.cmp: fast (Rust-backed) completion. Replaces nvim-cmp + its source
  -- constellation. Loads at startup so lsp.lua can pull LSP capabilities from it.
  'Saghen/blink.cmp',
  version = '*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      config = function()
        require('luasnip.loaders.from_snipmate').lazy_load()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
      dependencies = 'rafamadriz/friendly-snippets',
    },
    { 'Saghen/blink.compat', version = '*', lazy = true, opts = {} },
  },
  opts = {
    snippets = { preset = 'luasnip' },
    -- Use the pure-Lua fuzzy matcher. codesnap.nvim's bundled .so pollutes
    -- package.cpath and would otherwise hijack require('blink_cmp_fuzzy').
    fuzzy = { implementation = 'lua' },
    -- Keymaps mirror the old nvim-cmp behaviour:
    --   CR / C-l  -> accept (else fallback)
    --   Tab       -> snippet expand/jump, else accept, else fallback
    --   S-Tab     -> snippet jump back, else fallback
    --   C-j / C-k (+ scrollwheel) -> next / prev
    --   Esc       -> hide menu (else fallback)
    keymap = {
      preset = 'none',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-l>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'snippet_forward', 'accept', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<ScrollWheelDown>'] = { 'select_next', 'fallback' },
      ['<ScrollWheelUp>'] = { 'select_prev', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- NOTE: <Esc> is intentionally NOT mapped here. blink's 'hide' action would
      -- swallow Esc (preventing insert-mode exit). Letting it fall through to the
      -- default (and concessions.lua) keeps `Esc` -> exit insert working.
    },
    appearance = { nerd_font_variant = 'mono' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
      per_filetype = { sql = { 'vim-dadbod-completion', 'buffer', 'lsp' } },
      providers = {
        minuet = { module = 'minuet.blink', name = 'AI' },
        ['vim-dadbod-completion'] = { module = 'blink.compat.source', name = 'vim-dadbod-completion' },
      },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      -- Ghost-text preview of the top item (Copilot-style; AI suggestions show inline).
      ghost_text = { enabled = true },
    },
    signature = { enabled = true },
  },
}
