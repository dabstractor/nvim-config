return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  lazy = false,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- (mini.surround removed in Phase 2 dedup; nvim-surround provides ys/cs/ds.)

    require('mini.diff').setup()

    local map = require 'mini.map'
    map.setup {
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.gitsigns(),
        map.gen_integration.diagnostic(),
        map.gen_integration.diff(),
      },
    }

    -- require('mini.tabline').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'

    -- nvim-stagecoach live indicator: returns '' when idle (combine_groups
    -- renders an all-empty group as an invisible hl-only segment, so there is
    -- no stray space), else 'stagecoach  <phase>  <N>s'. pcall-guarded so an
    -- unloaded/missing module never breaks the statusline (plugin is lazy).
    local function stagecoach_segment()
      local ok, sc = pcall(require, 'stagecoach')
      if not ok then
        return ''
      end
      local s = sc.status()
      return (s == nil) and '' or s
    end

    -- set use_icons to true if you have a Nerd Font
    -- Custom `active` = mini.nvim default (H.default_content_active in
    -- lua/mini/statusline.lua) with a stagecoach group spliced into the left
    -- dev-info cluster. Re-check on mini.nvim updates. The `section_location`
    -- override below still applies because active() calls it lazily at render.
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
          local git = statusline.section_git { trunc_width = 40 }
          local diff = statusline.section_diff { trunc_width = 75 }
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
          local lsp = statusline.section_lsp { trunc_width = 75 }
          local filename = statusline.section_filename { trunc_width = 140 }
          local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
          local location = statusline.section_location { trunc_width = 75 }
          local search = statusline.section_searchcount { trunc_width = 75 }
          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            { hl = 'MiniStatuslineDevinfo', strings = { stagecoach_segment() } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          }
        end,
      },
    }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    require('mini.trailspace').setup()

    require('mini.align').setup()

    require('mini.indentscope').setup()

    require('mini.splitjoin').setup()

    require('mini.bufremove').setup()

    local hipatterns = require 'mini.hipatterns'

    hipatterns.setup {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    }
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
