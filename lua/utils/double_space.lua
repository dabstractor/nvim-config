--[[
Double-space jump navigation (prose cleanup).

Jump to the next/previous run of TWO or more spaces. Lands on the FIRST space
of the run, so a follow-up `x` deletes exactly one space and leaves a single
one behind. Built on search() so the search register (n/N) and hlsearch stay
untouched. Takes a count (`3]<Space>` skips three runs). Works in
visual mode (extends the selection) and after operators (`d]<Space>` deletes
up to the run, exclusive).

Bindings — vim's "unidirectional pair" bracket namespace ([ = previous,
] = next; same family as the builtin ]s spell-mistake, ]d define, ]q quickfix
motions — see :help bracket):
  ]<Space>   next run of 2+ spaces
  [<Space>   previous run

Repeat, f/F-style:
  ;   repeat the last double-space jump in the same direction
  ,   repeat it in the opposite direction

Any other cursor movement (j, w, f, ...) hands `;`/`,` straight back to their
native f/t repeat behavior, so nothing that relies on them is lost. Fixing
the run in place with `x` leaves the cursor where the jump left it, so the
repair rhythm
  ]<Space> x ; x ; x
walks and fixes consecutive runs.
]]
local M = {}

local PATTERN = ' \\{2,}'

-- Repeat-dispatcher state:
--   last_jump  'next' | 'prev' | nil -- direction of the last jump
--   armed_pos  where the jump left the cursor { buf, line, col }
--
-- The disarm check is POSITIONAL, not event-based: CursorMoved also fires on
-- text changes at an unmoved cursor (e.g. `x`, per :h CursorMoved), so we
-- keep the jump armed while the cursor sits at armed_pos — our own jump's
-- events and `x` fixing the run — and disarm it the moment the cursor turns
-- up somewhere else.
local last_jump, armed_pos = nil, nil

local function jump(back)
  return function()
    local flags = (back and 'b' or '') .. 'ws'
    for _ = 1, vim.v.count1 do
      if vim.fn.search(PATTERN, flags) == 0 then
        vim.notify('No run of 2+ spaces found', vim.log.levels.INFO)
        break
      end
    end
    last_jump = back and 'prev' or 'next'
    armed_pos = { vim.api.nvim_get_current_buf(), vim.fn.line '.', vim.fn.col '.' }
  end
end

---@param map function the utils.map helper
function M.setup(map)
  local next_run = jump(false)
  local prev_run = jump(true)

  for _, mode in ipairs { 'n', 'x', 'o' } do
    map(mode, '] ', next_run, { desc = 'Next run of 2+ spaces' })
    map(mode, '[ ', prev_run, { desc = 'Prev run of 2+ spaces' })
  end

  -- `;`/`,` repeat the double-space jump when one was just used (same /
  -- opposite direction, like f/F); otherwise they fall through to the native
  -- f/t repeat. Normal mode only — visual `;`/`,` stay native.
  map('n', ';', function()
    if last_jump == 'next' then
      next_run()
    elseif last_jump == 'prev' then
      prev_run()
    else
      pcall(vim.cmd, ('normal! %d;'):format(vim.v.count1))
    end
  end, { desc = 'Repeat last jump (native f/t repeat otherwise)' })

  map('n', ',', function()
    if last_jump == 'next' then
      prev_run()
    elseif last_jump == 'prev' then
      next_run()
    else
      pcall(vim.cmd, ('normal! %d,'):format(vim.v.count1))
    end
  end, { desc = 'Repeat last jump reversed (native f/t repeat otherwise)' })

  -- Disarm the jump (handing `;`/`,` back to native behavior) as soon as the
  -- cursor actually moves away from where the jump left it. `x` fires
  -- CursorMoved too (:h CursorMoved — text change), and it must NOT disarm
  -- the `;x;x` repair rhythm — hence comparing positions, not just events.
  local group = vim.api.nvim_create_augroup('double_space_jump', { clear = true })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = group,
    callback = function()
      if not last_jump or not armed_pos then
        return
      end
      local cur = { vim.api.nvim_get_current_buf(), vim.fn.line '.', vim.fn.col '.' }
      if not vim.deep_equal(cur, armed_pos) then
        last_jump = nil
      end
    end,
  })
end

return M
