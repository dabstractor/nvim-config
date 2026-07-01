return {
  {
    'jellydn/hurl.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'hurl', 'http' },
    config = function(_, opts)
      require('hurl').setup(opts)

      -- Function to read and set env variables from a file
      local function load_env_file(filepath)
        local f = io.open(filepath, 'r')
        if not f then return end

        for line in f:lines() do
          -- Skip comments and empty lines
          if not line:match('^%s*#') and line:match('=') then
            local key, value = line:match('^%s*([^=]+)%s*=%s*(.*)%s*$')
            if key and value then
              -- Remove quotes if present
              value = value:gsub('^["\'](.*)["\']$', '%1')
              vim.env[key] = value
            end
          end
        end
        f:close()
        vim.notify('Loaded env file: ' .. vim.fn.fnamemodify(filepath, ':t'), vim.log.levels.INFO)
      end

      -- Function to find and select env file
      local function select_env_file()
        local files = vim.fn.glob('*.env*', false, true)
        table.insert(files, '.env')

        -- Filter duplicates and existing files
        local unique_files = {}
        local seen = {}
        for _, file in ipairs(files) do
          if vim.fn.filereadable(file) == 1 and not seen[file] then
            table.insert(unique_files, file)
            seen[file] = true
          end
        end

        if #unique_files == 0 then
          vim.notify('No .env files found', vim.log.levels.WARN)
          return
        end

        vim.ui.select(unique_files, {
          prompt = 'Select Environment File:',
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if choice then
            load_env_file(choice)
          end
        end)
      end

      -- Create command
      vim.api.nvim_create_user_command('HurlEnv', select_env_file, {})

      -- Add filetype detection for .http files
      vim.filetype.add({
        extension = {
          http = 'hurl',
        },
      })

      -- Auto-load .env if it exists, or prompt if multiple
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'hurl' },
        callback = function()
          local files = vim.fn.glob('*.env*', false, true)
          if #files > 0 then
            -- Optional: automatically load .env if it's the only one
             if #files == 1 and files[1] == '.env' then
               load_env_file('.env')
             end
          end
        end,
      })
    end,
    opts = {
      debug = false,
      show_notification = false,
      mode = 'split',
      formatters = {
        json = { 'jq' },
        html = { 'prettier', '--parser', 'html' },
      },
    },
    keys = {
      { '<leader>hA', '<cmd>HurlRunner<CR>', desc = 'Run all requests' },
      { '<leader>ha', '<cmd>HurlRunnerAt<CR>', desc = 'Run request at cursor' },
      { '<leader>he', '<cmd>HurlRunnerToEntry<CR>', desc = 'Run to entry' },
      { '<leader>hE', '<cmd>HurlToggleMode<CR>', desc = 'Toggle popup/split' },
      { '<leader>hS', '<cmd>HurlEnv<CR>', desc = 'Select environment file' },
      { '<leader>hv', '<cmd>HurlVerbose<CR>', desc = 'Run verbose' },
      { '<leader>ha', ':HurlRunner<CR>', desc = 'Run selected', mode = 'v' },
    },
  },
}
