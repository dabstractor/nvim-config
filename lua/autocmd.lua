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

-- Remove orphaned ShaDa temp shards (.tmp.a … .tmp.z) left behind when an nvim
-- process is killed during exit (after writing the temp, before the rename over
-- main.shada). neovim never garbage-collects these, so they accumulate to E138.
-- Stopgap until fixed upstream. Only files idle >5 min are touched: a live write
-- finishes in milliseconds, so anything that stale is a guaranteed orphan
-- (won't clobber a concurrent write).
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('ShaDaTempCleanup', { clear = true }),
  desc = 'Remove stale ShaDa .tmp.X orphans',
  callback = function()
    local shards = vim.fn.glob(vim.fn.stdpath('state') .. '/shada/main.shada.tmp.*', false, true) or {}
    local now = os.time()
    for _, f in ipairs(shards) do
      if now - (vim.fn.getftime(f) or now) > 300 then
        os.remove(f)
      end
    end
  end,
})
