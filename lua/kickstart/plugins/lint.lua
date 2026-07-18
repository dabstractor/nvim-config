return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- Context gate: skip linting where it only produces noise.
      --   • pi's prompt editor writes the prompt to a temp file named
      --     `pi-editor-<ts>.pi.md` (see pi's interactive-mode.js). A bare prompt
      --     isn't a real markdown doc, so markdownlint always yells "first line
      --     should be a heading" -- suppress it automatically by path.
      --   • Opt-out anywhere else: launch with `NO_LINT=1` in the env, or pass
      --     `--cmd 'let g:no_lint=1'`. Handy for e.g. an Obsidian scratchpad.
      local function should_skip(bufnr)
        bufnr = bufnr or 0
        if vim.env.NO_LINT or vim.g.no_lint then
          return true
        end
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match 'pi%-editor%-.+%.pi%.md$' then
          return true
        end
        return false
      end

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function(event)
          if should_skip(event.buf) then
            return
          end
          -- pcall: a linter whose binary is missing must never throw. Previously a
          -- missing `markdownlint` surfaced as a blocking "Press ENTER" error during
          -- session restore; this keeps lint failures non-fatal.
          pcall(require('lint').try_lint)
        end,
      })
    end,
  },
}
