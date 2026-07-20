-- pi-bridge.nvim: renders pi's live completion inside the $EDITOR nvim that pi
-- launches on Ctrl+G (the split-editor package or pi's native external editor).
-- Dormant outside a pi-spawned session — activates only when PI_NVIM_BRIDGE is
-- present in the environment.
--
-- Requires the companion pi extension `pi-nvim-bridge` to be installed too:
--   pi install git:github.com/dabstractor/pi-nvim-bridge   (then `pi list`)
--
-- `lazy = false` is required so the VimEnter startup shim (plugin/pi-bridge.lua)
-- sources BEFORE the VimEnter event that triggers activation.
--
-- The repo ships its nvim runtime files (lua/pi-bridge/, plugin/, ftplugin/,
-- doc/) at the ROOT, so the clone lands directly on `runtimepath` — no `dir`/
-- `sub` needed (and none would be portable: no plugin manager clones a subdir as
-- the rtp root). For live development against a local checkout instead of the
-- GitHub clone, add:  dir = "~/projects/pi-nvim-bridge"
return {
  'dabstractor/pi-nvim-bridge',
  lazy = false,
  config = function()
    require('pi-bridge').setup {}
  end,
}
