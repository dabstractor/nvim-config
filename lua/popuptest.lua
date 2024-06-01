local Popup = require 'nui.popup'
local event = require('nui.utils.autocmd').event

local testpopup = Popup {
  enter = true,
  focusable = true,
  border = {
    style = 'rounded',
  },
  position = '50%',
  size = {
    width = '80%',
    height = '60%',
  },
}

function open_test_popup()
  testpopup:mount()
end

-- unmount component when cursor leaves buffer
testpopup:on(event.BufLeave, function()
  vim.g.testpopup:unmount()
end)

-- set content
vim.api.nvim_buf_set_lines(testpopup.bufnr, 0, 1, false, { 'Hello World' })

vim.keymap.set('n', '<leader>tp', open_test_popup)
