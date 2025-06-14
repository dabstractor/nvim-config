--[[ -- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = require 'utils.map'

require 'concessions'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode

map('t', '<C-c>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map({ 'n', 'v', 'i' }, '<C-c>', '"+', { desc = 'Activate system clipboard', silent = true, noremap = true })

-- Buffer Navigation
-- <Leader>1-9 will jump to that tab
for i = 1, 9 do
  map('n', '<Leader>' .. i, function()
    require('utils.buffers').switch_to_tab(i)
  end, { desc = 'Go to buffer ' .. i })
end

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', ':winc h<cr>', { desc = 'Move focus to the left pane', silent = true })
map('n', '<C-l>', ':winc l<cr>', { desc = 'Move focus to the right pane', silent = true })
map('n', '<C-k>', ':winc k<cr>', { desc = 'Move focus to the upper pane', silent = true })
map('n', '<C-j>', ':winc j<cr>', { desc = 'Move focus to the lower pane', silent = true })

map({ 'n', 'i' }, '<C-ScrollWheelUp>', ':winc h<cr>', { desc = 'Move focus to the left pane', silent = true })
map({ 'n', 'i' }, '<C-ScrollWheelDown>', ':winc l<cr>', { desc = 'Move focus to the right pane', silent = true })
map({ 'n', 'i' }, '<C-S-ScrollWheelUp>', ':winc k<cr>', { desc = 'Move focus to the upper pane', silent = true })
map({ 'n', 'i' }, '<C-S-ScrollWheelDown>', ':winc j<cr>', { desc = 'Move focus to the lower pane', silent = true })

-- Window tiling
map({ 'n', 'i' }, '<C-A-o>', ':only<cr>', { desc = 'Pane becomes the only one', silent = true })
map({ 'n', 'i' }, '<C-A-w>', ':close<cr>', { desc = 'Pane Close', silent = true })

map({ 'n', 'i' }, '<C-A-h>', ':vnew<cr>', { desc = 'Pane open to the right', silent = true })
map({ 'n', 'i' }, '<C-A-l>', ':vsplit<cr>', { desc = 'Pane open to the right (current file)', silent = true })
map({ 'n', 'i' }, '<C-A-j>', ':new<cr>', { desc = 'Pane open below', silent = true })
map({ 'n', 'i' }, '<C-A-k>', ':split<cr>', { desc = 'Pane open below', silent = true })

-- Window tile resizing
map({ 'n', 'i' }, '<C-S-A-h>', ':vertical resize -2<cr>', { desc = 'Resize vertical pane down', silent = true })
map({ 'n', 'i' }, '<C-S-A-j>', ':resize -2<cr>', { desc = 'Resize horizontal pane down', silent = true })
map({ 'n', 'i' }, '<C-S-A-k>', ':resize +2<cr>', { desc = 'Resize horizontal pane up', silent = true })
map({ 'n', 'i' }, '<C-S-A-l>', ':vertical resize +2<cr>', { desc = 'Resize vertical pane up', silent = true })

map({ 'n', 'i' }, '<C-A-ScrollWheelUp>', ':vertical resize -2<cr>', { desc = 'Resize vertical pane down', silent = true })
map({ 'n', 'i' }, '<C-A-ScrollWheelDown>', ':vertical resize +2<cr>', { desc = 'Resize vertical pane down', silent = true })
map({ 'n', 'i' }, '<C-A-S-ScrollWheelDown>', ':resize -2<cr>', { desc = 'Resize horizontal pane down', silent = true })
map({ 'n', 'i' }, '<C-A-S-ScrollWheelUp>', ':resize +2<cr>', { desc = 'Resize horizontal pane up', silent = true })

local closeTab = function()
  require('mini.bufremove').unshow()
end

-- map('n', '<Leader>w', closeTab, { desc = 'Close window', silent = true })
-- map('n', '<Leader>q', ':close<cr>', { desc = 'Close window', silent = true })

-- Custom mappings

map('n', '<C-CR>', ':', { desc = 'CMD enter command mode' })

-- Generic Text Editor mappings --

-- map Ctrl + s to Save
map({ 'n', 'i' }, '<C-s>', ':w<CR>', { desc = 'Save File', silent = true, noremap = true })
map('n', '<Leader>s', ':w<CR>', { desc = 'Save File', silent = true })

-- map Ctrl+F to telescope live_grep
map({ 'n', 'i' }, '<C-S-f>', '<cmd>Telescope live_grep<cr>', { desc = 'Find Text in Files (Normal Mode)' })

-- map Ctrl + w to close Buffer/tab
-- map({ 'i', 'n' }, '<C-w>', closeTab, { desc = 'Close File', silent = true })
-- map({ 'i', 'n' }, '<C-S-w>', ':bd!<cr>', { desc = 'Close File (forced)', silent = true })
map({ 'i', 'n', 'v' }, '<C-A-q>', closeTab, { desc = 'Pane Close', silent = true })
map({ 'i', 'n', 'v' }, '<C-q>', ':bd<cr>', { desc = 'Close File', silent = true })
map({ 'i', 'n', 'v' }, '<C-q><C-q>', ':bd!<cr>', { desc = 'Close File', silent = true })
map({ 'i', 'n', 'v' }, '<C-q><C-q><C-q>', ':q<cr>', { desc = 'Close File', silent = true })
map({ 'i', 'n', 'v' }, '<C-q><C-q><C-q><C-q>', ':q!<cr>', { desc = 'Close File', silent = true })
map({ 'i', 'n', 'v' }, '<C-q><C-q><C-q><C-q>', ':q!<cr>', { desc = 'Close File', silent = true })

-- map Ctrl + t to new buffer
map({ 'n', 'i' }, '<C-t>', '<cmd>enew<cr>', { desc = 'New Buffer', silent = true })

-- map Ctrl + q to quit (press enter to confirm, add ! to force)
-- map({ 'n', 'i' }, '<leader>q', '<cmd>qa', { desc = 'Close Application', silent = true })
-- map({ 'n', 'i' }, '<C-S-q>', '<cmd>qa<cr>', { desc = 'Close Application', silent = true })
-- map({ 'n', 'i' }, '<C-A-S-q>', '<cmd>qa!<cr>', { desc = 'Close Application without saving', silent = true })

-- map Ctrl + ] and Ctrl + [ to indent/unindent code
map({ 'n', 'i' }, '<C-]>', '>>', { desc = 'Indent', silent = true })
map({ 'n', 'i' }, '<C-[>', '<<', { desc = 'Indent Backward', silent = true })
map('v', '<C-[>', '<gv', { desc = 'Indent Backward (Visual Mode)', silent = true })
map('v', '<C-]>', '>gv', { desc = 'Indent (Visual Mode)', silent = true })
map({ 'n', 'i' }, '<C-ScrollWheelRight>', '>>', { desc = 'Indent', silent = true })
map({ 'n', 'i' }, '<C-ScrollWheelLeft>', '<<', { desc = 'Indent Backward', silent = true })
map('v', '<C-ScrollWheelRight>', '>gv', { desc = 'Indent (Visual Mode)', silent = true })
map('v', '<C-ScrollWheelLeft>', '<gv', { desc = 'Indent Backward (Visual Mode)', silent = true })

-- map Ctrl+Shift+t to reopen last closed tab with LastBuf
map({ 'n', 'i' }, '<C-S-t>', ':LastBuf', { desc = 'Reopen last closed tab', silent = true })

-- map Ctrl + b to Neotree open
map({ 'n', 'i' }, '<C-b>', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle Neotree (Normal Mode)' })

-- map Ctrl+P to telescope find Files
map({ 'n', 'i', 'v' }, '<C-P>', '<cmd>Telescope find_files<cr>', { desc = 'Find Files (Normal Mode)', noremap = true })
-- map("i", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find Files (Normal Mode)" })

-- Ctrl+Shift+P to toggle command menu (":")
map({ 'n', 'i' }, '<C-S-p>', ':Telescope buffers<cr>', { desc = 'Fuzzy Find In Open Buffers', silent = true })

-- map Ctrl+A to select all
map({ 'n', 'i' }, '<C-a>', '<cmd>normal ggVG<cr>', { desc = 'Select all (Normal Mode)', silent = true })

-- map Ctrl + / to comment line

local comment = function()
  require('Comment.api').toggle.linewise.current()
end

map('n', '<C-/>', comment, { noremap = true, desc = 'Comment line (Normal mode)', silent = true })
map('i', '<C-/>', comment, { noremap = true, desc = 'Comment line (Visual Mode)', silent = true })
map('v', '<C-/>', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<cr>gv=gv', { desc = 'Comment line (Visual Mode)', silent = true })

map('v', '<C-A-/>', '<C-\\><C-N><Cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })

map('v', '<C-S>?', function()
  require('Comment.api').toggle.blockwise(vim.fn.visualmode())
  vim.cmd 'normal! gv=gv'
end, { desc = 'Comment line (Visual Mode)', silent = true })

map(
  'v',
  '<C-Alt-/>',
  '<Cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>',
  { noremap = true, silent = true, desc = 'Comment block (Visual Mode)' }
)

-- map Ctrl + o to open project
map('n', '<Leader>oo', ':cd ~/', { noremap = true, desc = 'Open Project' })

-- map Ctrl + Shift + o to open file
map('n', '<Leader>of', ':e ', { noremap = true, desc = 'Open File' })

-- map ~ to open project
map('n', '~', ':cd ~/', { noremap = true, desc = 'Open Home Directory' })

-- map ! to run shell command
map('n', '!', ':! ', { noremap = true, desc = 'Run shell command' })

-- map Ctrl+! to run shell command with output to buffer
map('n', '<C-1>', ':r! ', { noremap = true, desc = 'Run shell command output to buffer' })

-- map Space + lg to LazyGit
map('n', '<Leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit', silent = true })
--
-- map Space + ld to LazyDocker
map('n', '<Leader>ld', '<cmd>LazyDocker<cr>', { desc = 'LazyDocker', silent = true })

-- map Space + gd to Gitsigns diffthis
map('n', '<Leader>gd', '<cmd>Gitsigns diffthis<cr>', { desc = 'Git Diff (Normal Mode)' })
map('n', '<Leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit' })

-- map <Tab> to next buffer
map('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Switch to next tab' })
map('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Switch to next tab' })

-- map Ctrl+Shift+Enter to ZenMode
map({ 'n', 'i', 'v' }, '<C-S-Enter>', '<cmd>ZenMode<cr>', { desc = 'Zen Mode' })

-- Undo/Redo
map({ 'n', 'i', 'v' }, '<C-z>', 'u', { desc = 'Undo' })
map({ 'n', 'i', 'v' }, '<C-y>', '<C-r>', { desc = 'Redo' })
map({ 'n', 'i', 'v' }, '<C-S-z>', '<C-r>', { desc = 'Redo' })

-- Tabs
map({ 'n', 'i', 'v' }, '<C-S-t>', '<C-o>', { desc = 'Open last closed buffer' })

-- Minimap
map({ 'n', 'v' }, '<Leader>m', ":lua require('mini.map').toggle()<cr>", { desc = 'Toggle Minimap', silent = true })

-- Move lines up and down
map({ 'n', 'i' }, '<C-S-j>', ':m +1<cr>', { desc = 'Move line down', silent = true })
map({ 'n', 'i' }, '<C-S-k>', ':m -2<cr>', { desc = 'Move line up', silent = true })
map('v', '<C-S-j>', ":m '>+1<cr>gv=gv", { desc = 'Move line down', silent = true })
map('v', '<C-S-k>', ":m '<-2<cr>gv=gv", { desc = 'Move line up', silent = true })

-- Map <leader>rw to replace all instances of current word
map('n', '<leader>rw', ':%s/\\<<C-r><C-w>\\>//g<left><left>', { noremap = true, desc = 'Replace all instances of current word' })

-- Undo Tree
map({ 'i', 'n' }, '<C-S-u>', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle Undo Tree' })
map({ 'n', 'i', 'v' }, '<C-A-S-U>', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle Undo Tree', silent = true })

-- BufSurf

map({ 'n', 'i', 'v' }, '<A-l>', '<cmd>BufSurfForward<cr>', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<A-h>', '<cmd>BufSurfBack<cr>', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<A-ScrollWheelDown>', '<cmd>BufSurfForward<cr>', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<A-ScrollWheelUp>', '<cmd>BufSurfBack<cr>', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<X1Mouse>', '<cmd>BufSurfBack<cr>', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<X2Mouse>', '<cmd>BufSurfForward<cr>', { noremap = true, silent = true })

-- Tabs

map({ 'n', 'v' }, '<leader>n', ':enew<cr>', { desc = 'Blank new file', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>tt', ':tab split<cr>', { desc = 'New Tab', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>tc', ':tabclose<cr>', { desc = 'Close tab', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>tl', ':tabnext<cr>', { desc = 'Next tab', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>th', ':tabprevious<cr>', { desc = 'Previous tab', silent = true, noremap = true })
-- map({ 'n', 'v' }, '<leader><Tab>', ':tabnext<cr>', { desc = 'Next tab', silent = true, noremap = true })
-- map({ 'n', 'v' }, '<leader><S-Tab>', ':tabprevious<cr>', { desc = 'Previous tab', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>l', '<cmd>tabnext<cr>', { desc = 'Switch to next tab' })
map({ 'n', 'v' }, '<leader>h', '<cmd>tabprevious<cr>', { desc = 'Switch to previous tab' })

-- Rest
map({ 'n', 'v' }, '<leader>rr', ':Rest run<cr>', { desc = 'Rest Run', silent = true, noremap = true })
map({ 'n', 'v' }, '<leader>re', ':Telescope rest select_env<cr>', { desc = 'Rest Run', silent = true, noremap = true })

-- Escape.nvim
map({ 'n', 'v' }, '<leader>e', ':lua require("escape").escape', { noremap = true, silent = true })

-- DapInfo
map('n', '<leader>br', '<cmd>DapInfoRevealBp<cr>', { desc = 'Dap Info Show Breakpoint Info', silent = true })
map('n', '<leader>bn', '<cmd>DapInfoNextBp<cr>', { desc = 'Dap Info Next Breakpoint', silent = true })
map('n', '<leader>bp', '<cmd>DapInfoPrevBp<cr>', { desc = 'Dap Info Previous Breakpoint', silent = true })
map('n', '<leader>bu', '<cmd>DapInfoUpdateBp<cr>', { desc = 'Dap Info Update Breakpoint', silent = true })

-- CodeCompanion
map('n', '<leader>cc', '<cmd>CodeCompanionChat<cr>', { desc = 'Code Companion Prompt Chat', silent = true })
map('n', '<leader>cm', '<cmd>CodeCompanionCmd<cr>', { desc = 'Code Companion Prompt Command', silent = true })
map('n', '<leader>cp', '<cmd>CodeCompanion<cr>', { desc = 'Code Companion Prompt', silent = true })
map('n', '<leader>cn', '<cmd>CodeCompanionActions<cr>', { desc = 'Code Companion Actions', silent = true })

map('v', '<leader>cc', "<cmd>'<,'>CodeCompanionChat<cr>", { desc = 'Code Companion Prompt Chat', silent = true })
map('v', '<leader>cm', "<cmd>'<,'>CodeCompanionCmd<cr>", { desc = 'Code Companion Prompt Command', silent = true })
map('v', '<leader>cp', "<cmd>'<,'>CodeCompanion<cr>", { desc = 'Code Companion Prompt', silent = true })
map('v', '<leader>cn', "<cmd>'<,'>CodeCompanionActions<cr>", { desc = 'Code Companion Actions', silent = true })

map({ 'n', 'v' }, '<leader>cs', '<cmd>CodeCompanionSave<cr>', { desc = 'Code Companion Save Chats', silent = true })
map({ 'n', 'v' }, '<leader>cs', '<cmd>CodeCompanionLoad<cr>', { desc = 'Code Companion Load Chats', silent = true })

map('n', 'gV', '`[v`]', { desc = 'Resume last selection' })

map('n', '<C-S-y>', 'y^', { desc = 'Yank to beginning of line' })
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

local makeScroll = function(direction)
  local axis = (direction == 'h' or direction == 'l') and 'h' or 'v'

  return function()
    local scroll = axis == 'v' and vim.opt.scroll:get() or vim.opt.sidescroll:get() or 10
    vim.api.nvim_feedkeys(scroll .. direction, 'n', true)
  end
end

local makeInsertScroll = function(direction)
  local scrollFn = makeScroll(direction)

  return function()
    vim.cmd 'stopinsert'
    scrollFn()
    vim.api.nvim_feedkeys('i', 'n', true)
  end
end

map({ 'n', 'v' }, '<ScrollWheelUp>', makeScroll 'k', { desc = 'Scroll up' })
map({ 'n', 'v' }, '<ScrollWheelDown>', makeScroll 'j', { desc = 'Scroll down' })
map('i', '<ScrollWheelUp>', makeInsertScroll 'k', { desc = 'Scroll up', silent = true })
map('i', '<ScrollWheelDown>', makeInsertScroll 'j', { desc = 'Scroll down', silent = true })

map({ 'n', 'v' }, '<ScrollWheelLeft>', makeScroll 'h', { desc = 'Scroll left' })
map({ 'n', 'v' }, '<ScrollWheelRight>', makeScroll 'l', { desc = 'Scroll right' })
map('i', '<ScrollWheelLeft>', makeInsertScroll 'h', { desc = 'Scroll left', silent = true })
map('i', '<ScrollWheelRight>', makeInsertScroll 'l', { desc = 'Scroll Right', silent = true })

map({ 'n', 'i', 'v' }, '<S-ScrollWheelUp>', '{', { desc = 'Scroll up to whitespace', silent = true })
map({ 'n', 'i', 'v' }, '<S-ScrollWheelDown>', '}', { desc = 'Scroll down to whitespace', silent = true })
map({ 'n', 'i', 'v' }, '<Mouse4>', '<cmd>BufSurfBack<cr>', { desc = 'Navigate back', silent = true })
map({ 'n', 'i', 'v' }, '<Mouse5>', '<cmd>BufSurfForward<cr>', { desc = 'Navigate forward', silent = true })

-- Add normal paste back into command mode:
map('c', '<C-S-V>', '<C-R>*', { desc = 'Paste from clipboard' })

require 'user.keymaps'
