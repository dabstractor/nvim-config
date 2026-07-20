return {
  'bullets-vim/bullets.vim',
  ft = { 'markdown', 'text' },
  init = function()
    -- Enable bullets for markdown files
    vim.g.bullets_enabled_filetypes = { 'markdown', 'text' }
  end,
}
