-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

vim.opt.autoindent = false
vim.opt.smartindent = false

-- Save undo history
vim.opt.undofile = true

-- Automatically handle swap files without prompting
-- This prevents the ATTENTION dialog when opening files with existing swap files
vim.opt.shortmess:append 'A'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 4

-- don't wrap lines by default
vim.opt.wrap = false

-- tab settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.colorcolumn = '80'

-- titlestring
vim.opt.title = true
vim.opt.titleold = ''

if vim.g.custom_titlestring then
  vim.opt.titlestring = vim.g.custom_titlestring
else
  vim.opt.titlestring = vim.fn.expand '%:p:h:t' .. ' - %{&filetype}'
end

vim.g.lazygit_floating_window_scaling_factor = 0.98

-- [[ Personal settings (merged from the former lua/user/config.lua) ]]

-- Sync clipboard between OS and Neovim.
--  Uncomment this option if you want your OS clipboard to sync with Neovim.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

vim.g.dap_home = os.getenv 'HOME' .. '/src/'
vim.g.incline_config = {
  hide = {
    cursorline = true,
  },
}

vim.opt.scrolloff = 10

vim.g.scroll_distance_ratio = 0.3
vim.g.sidescroll_distance_ratio = 0.05
vim.opt.scroll = 1
vim.opt.sidescroll = 1

-- GUI font and Neovide appearance (merged from the former lua/user/font.lua)
-- format: '<Font Name>:h<size>(:<style flags>)'
-- vim.opt.guifont = 'FiraMono Nerd Font Mono:h15'

-- use a bold font for regular text and set normal bold to extrabold
if not vim.g.neovide then
  vim.opt.guifont = 'JetBrainsMono Nerd Font:h16:b'
else
  vim.opt.guifont = 'JetBrainsMono Nerd Font:h18:b'
  vim.g.neovide_scale_factor = 0.94
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  vim.g.neovide_vfx_particle_lifetime = 1.5
  vim.g.neovide_vfx_particle_density = 10
  vim.g.neovide_cursor_vfx_particle_curl = 2.0
end
vim.cmd [[ highlight! link Bold ExtraBold ]]
