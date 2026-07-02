return {
  'okuuva/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      condition = function(buf)
        return vim.g.autosave_enabled
      end,
    }
  end,
}
