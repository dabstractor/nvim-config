-- Auto-pane: size-aware smart split — a Lua port of tmux-auto-pane.
-- Loaded from the local dev checkout (lazy resolves `dir`, `~` included).
return {
  {
    'dabstractor/nvim-auto-pane',
    dir = '~/projects/nvim-auto-pane',
    lazy = false,
    -- Same option names/semantics as the @auto-pane-* tmux options. Values
    -- mirror the user's tmux.conf so nvim splits behave like tmux splits.
    config = function()
      require('nvim-auto-pane').setup {
        min_columns = 120, -- @auto-pane-min-columns
        min_rows = 80, -- @auto-pane-min-rows
        aspect_ratio = 3.2, -- @auto-pane-aspect-ratio
        -- right_width = 220, -- @auto-pane-right-width  (side-by-side: right pane -> 220 cols)
        -- right_threshold = 315, -- @auto-pane-right-threshold (...only when pane > 315 wide)
        split_key = '<C-w><CR>', -- smart split, current buffer
        split_new_key = '<C-w><C-CR>', -- smart split, new empty buffer
        -- reverse_key = '<C-w><S-CR>', -- reversed split (enable if your terminal sends S-Enter)
      }
    end,
  },
}
