-- String escape/unescape helper.
-- Replaces the old escape.nvim (which was never installed and errored on keypress).
-- <leader>es toggles the current line / visual selection between escaped and
-- unescaped form (e.g. {"a":"b"} <-> {\"a\":\"b\"}). Operates in-place; undo to revert.
local M = {}

local ESC = { ['\\'] = '\\\\', ['"'] = '\\"', ["'"] = "\\'", ['\n'] = '\\n', ['\t'] = '\\t', ['\r'] = '\\r' }
local function escape(s)
  return (s:gsub('[\\%"\'\n\t\r]', ESC))
end

local UNESC = { n = '\n', t = '\t', r = '\r', ['"'] = '"', ["'"] = "'", ['\\'] = '\\' }
local function unescape(s)
  return (s:gsub('\\([ntr"\'\\])', UNESC))
end

-- If the text looks already-escaped (contains a backslash escape), unescape it;
-- otherwise escape it. Returns (new_text, action_label).
function M.toggle(s)
  if s:find('\\', 1, true) then
    return unescape(s), 'unescaped'
  end
  return escape(s), 'escaped'
end

-- Normal mode: toggle the current line.
function M.line()
  local new, action = M.toggle(vim.api.nvim_get_current_line())
  vim.api.nvim_set_current_line(new)
  vim.notify('String ' .. action, vim.log.levels.INFO)
end

-- Visual mode: toggle the selected lines.
function M.selection()
  local s = vim.api.nvim_buf_get_mark(0, '<')
  local e = vim.api.nvim_buf_get_mark(0, '>')
  if not s or not e or s[1] == 0 then
    return M.line()
  end
  local lines = vim.api.nvim_buf_get_lines(0, s[1] - 1, e[1], false)
  local new, action = M.toggle(table.concat(lines, '\n'))
  vim.api.nvim_buf_set_lines(0, s[1] - 1, e[1], false, vim.split(new, '\n', { plain = true }))
  vim.notify('String ' .. action, vim.log.levels.INFO)
end

return M
