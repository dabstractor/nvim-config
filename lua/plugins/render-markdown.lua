-- Promoted to its own spec in Phase 2 (was a dependency of avante.nvim, which was
-- removed). Renders markdown in-buffer (headings, lists, checkboxes, code blocks).
return {
  'MeanderingProgrammer/render-markdown.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-web-devicons' },
  opts = {
    file_types = { 'markdown' },
  },
  ft = { 'markdown' },
}
