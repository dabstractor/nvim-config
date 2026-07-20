-- pi-editor.nvim: renders pi's live completion inside the $EDITOR nvim that pi
-- launches on Ctrl+G. Dormant outside a pi-spawned session (keys on
-- $PI_EDITOR_BRIDGE). The companion pi extension `pi-editor-bridge` must be
-- installed (it is — `pi list` shows it).
--
-- `dir` points at the LOCAL clone's plugin/ subdir so edits to the repo are
-- picked up live (good for testing). The plugin/ dir is the runtimepath root,
-- so plugin/pi-editor.lua (VimEnter shim), lua/pi-editor/*, ftplugin/, and
-- doc/ all resolve correctly.
--
-- NOTE: lazy = false is required so the VimEnter startup shim sources BEFORE
-- the VimEnter event that triggers activation.
-- (The plugin README's `sub = "plugin"` is not a real lazy.nvim key; pointing
-- `dir` at the subdir is the supported equivalent.)
return {
  'dabstractor/pi-nvim-bridge', -- name (dir makes lazy skip any git fetch)
  dir = '/home/dustin/projects/pi-nvim-bridge/plugin',
  lazy = false,
  config = function()
    require('pi-editor').setup({})
  end,
}