return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'

  -- which-key v3 automatically discovers descriptions from each keymap's `desc`
  -- field, so individual mappings do NOT need to be listed here. This `spec`
  -- only declares group/prefix labels (so the popup shows a heading for each
  -- leader group) plus any keys that don't map to a real keymap. See `:h which-key.nvim`.
  opts = {
    spec = {
      -- <leader> groups (one per prefix actually in use)
      { '<leader>a', group = 'Aider' },
      { '<leader>b', group = 'Debug' },
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Document' },
      { '<leader>e', group = 'Escape' },
      { '<leader>f', group = 'Format' },
      { '<leader>g', group = 'Git' },
      { '<leader>o', group = 'Open' },
      { '<leader>r', group = 'Replace' },
      { '<leader>s', group = 'Search' },
      { '<leader>t', group = 'Tabs' },
      { '<leader>w', group = 'Workspace' },

      -- NOTE: <leader>h and <leader>l are intentionally NOT declared as groups.
      -- They are immediate "switch to previous/next tab" mappings used often,
      -- so which-key shows that description instead of a group header. The few
      -- sub-keys that exist (<leader>lg, <leader>ld, and hurl's <leader>h* in
      -- .http files) are still auto-discovered and expand on their own.

      -- non-leader prefix groups
      { 'g', group = 'Goto' },
      { '<C-w>', group = 'Window' },
      { '[', group = 'Prev' },
      { ']', group = 'Next' },
    },
  },
}
