vim.cmd [[autocmd FileType markdown set tw=160|set wrap]]

-- Recompute scroll/sidescroll from window size (merged from lua/user/autocmd.lua)
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinResized' }, {
  pattern = '*',
  callback = function()
    if vim.g.scroll_distance_ratio ~= nil then
      local height = vim.api.nvim_win_get_height(0)
      local scroll_val = math.floor(height * vim.g.scroll_distance_ratio)
      vim.opt.scroll = math.max(1, scroll_val)
    end

    -- if sidescroll_distance_ratio is set, use it:
    if vim.g.sidescroll_distance_ratio ~= nil then
      local width = vim.api.nvim_win_get_width(0)
      local scroll_val = math.floor(width * vim.g.sidescroll_distance_ratio)
      vim.opt.sidescroll = math.max(1, scroll_val)
    end
  end,
})
