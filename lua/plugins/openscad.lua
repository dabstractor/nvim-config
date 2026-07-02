vim.cmd [[ autocmd BufRead,BufNewFile *.scad set filetype=openscad ]]

return {
  'salkin-mada/openscad.nvim',
  config = function()
    require 'openscad'
    -- load snippets, note requires
    vim.g.openscad_load_snippets = true
  end,
  dependencies = { 'L3MON4D3/LuaSnip' },
}
