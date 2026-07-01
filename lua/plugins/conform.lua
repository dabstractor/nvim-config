local disable_filetypes = { c = true, cpp = true }

-- Nested table = "try the first, fall back to the second".
-- prettierd is a long-running Prettier daemon (much faster); prettier is the
-- plain CLI fallback. Both honor the project's .prettierrc / package.json config.
local prettier = { { 'prettierd', 'prettier' } }

return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>fm',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      if vim.g.disable_formatting then
        return false
      end

      -- NEVER format a broken file.
      --
      -- If, say, a template literal (backtick) is left unclosed, everything
      -- below it stops being a string and becomes live JavaScript. At that
      -- point the formatter happily rewrites your CSS-in-JS as if it were
      -- arithmetic -- `min-width` becomes `min - width` (subtraction),
      -- `100%` becomes `100 %` (modulo), braces get reshuffled, etc.
      --
      -- ts_ls/typescript-tools/eslint all flag that garbage with ERROR-level
      -- diagnostics the instant it appears, so bailing here prevents the
      -- formatter from ever running against a mis-parsed buffer.
      --
      -- NOTE: the manual `<leader>fm` mapping above is intentionally NOT
      -- gated, so you can still force a format when you really mean it.
      local errors = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
      if #errors > 0 then
        vim.notify(
          ('Skipping format-on-save: %d error(s) in buffer'):format(#errors),
          vim.log.levels.WARN,
          { title = 'conform' }
        )
        return false
      end

      return {
        timeout_ms = 5000,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = { 'prettierd', 'prettier', 'jq' },
      jsonc = prettier,
      html = prettier,
      css = prettier,
      scss = prettier,
      less = prettier,
      markdown = prettier,
      graphql = prettier,
      yaml = { 'yamlfmt', 'yamlfix' },
      openscad = { 'openscad-lsp' },
    },
  },
}
