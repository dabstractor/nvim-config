return {
  'okuuva/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      condition = function(buf)
        -- Gate every autosave on the runtime flag. Compare to `true` explicitly:
        -- the flag is a boolean (seeded from NVIM_AUTOSAVE in user/config.lua),
        -- and this also dodges Lua's "0 is truthy" trap if it's ever a number.
        return vim.g.autosave_enabled == true
      end,
    }

    local function report()
      vim.notify('Autosave ' .. (vim.g.autosave_enabled and 'ON' or 'OFF'), vim.log.levels.INFO)
    end

    vim.api.nvim_create_user_command('AutosaveToggle', function()
      vim.g.autosave_enabled = not (vim.g.autosave_enabled == true)
      report()
    end, { desc = 'Toggle autosave on/off' })

    vim.api.nvim_create_user_command('AutosaveOn', function()
      vim.g.autosave_enabled = true
      report()
    end, { desc = 'Enable autosave' })

    vim.api.nvim_create_user_command('AutosaveOff', function()
      vim.g.autosave_enabled = false
      report()
    end, { desc = 'Disable autosave' })

    vim.keymap.set('n', '<leader>ua', '<cmd>AutosaveToggle<cr>', { desc = 'Toggle [a]utosave' })
  end,
}
