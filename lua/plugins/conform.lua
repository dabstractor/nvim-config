local disable_filetypes = { c = true, cpp = true }

-- `stop_after_first = true` (inside the list) means "use the first available
-- formatter, ignore the rest" -- i.e. prefer the prettierd daemon, but fall
-- back to the plain prettier CLI if prettierd isn't installed. Both honor the
-- project's .prettierrc / package.json config.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

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

      -- Only refuse to format when the file is *structurally* broken.
      --
      -- The footgun this guards against: an unclosed template literal (or a
      -- stray bracket) makes everything below it parse as live JavaScript, so
      -- the formatter rewrites your CSS-in-JS as arithmetic -- `min-width`
      -- becomes `min - width` (subtraction), `100%` becomes `100 %` (modulo),
      -- braces get reshuffled, etc.
      --
      -- Those structural breaks show up as tsserver SYNTAX diagnostics (code
      -- < 2000, e.g. 1005 "';' expected", 1109 "Expression expected").
      -- Ordinary type errors from a mid-refactor file are SEMANTIC (code
      -- 2xxx+, e.g. 2322/2304) and do NOT block formatting, so you can keep
      -- formatting while you work -- only an actually-unparseable file is
      -- skipped.
      --
      -- NOTE: the manual `<leader>fm` mapping above is intentionally NOT
      -- gated, so you can still force a format when you really mean it.
      local has_syntax_error = false
      for _, d in ipairs(vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })) do
        local code = d.code
        if code == nil and d.user_data and d.user_data.lsp then code = d.user_data.lsp.code end
        if type(code) == 'number' and code < 2000 then
          has_syntax_error = true
          break
        end
      end
      if has_syntax_error then
        vim.notify(
          'Skipping format-on-save: syntax error in buffer',
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
      json = { 'prettierd', 'prettier', 'jq', stop_after_first = true },
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
