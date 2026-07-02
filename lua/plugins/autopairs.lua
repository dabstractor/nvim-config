return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {}
    -- (The old nvim-cmp "add parens on confirm" hook is removed; blink is the
    -- completion engine now. Core auto-pairing of brackets/quotes still works.)
  end,
}
