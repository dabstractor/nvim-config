return {
  -- Enhances Neovim's native `gc`/`gcc`/`gb` commenting with treesitter-aware
  -- commentstrings (e.g. JSX -> {/* */}, CSS-in-JS -> /* */). Replaces both
  -- numToStr/Comment.nvim and JoosepAlviste/nvim-ts-context-commentstring.
  'folke/ts-comments.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {},
}
