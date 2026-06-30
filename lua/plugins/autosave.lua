return {
  'okuuva/auto-save.nvim',
  config = function()
    print(vim.inspect(vim.g.autosave_enabled))
    require('auto-save').setup {
      condition = function(buf)
        return vim.g.autosave_enabled
      end,
    }
  end,
}
