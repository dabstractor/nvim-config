return { -- Highlight, edit, and navigate code
  -- nvim-treesitter (main branch) is now a slim *parser manager*. Highlighting,
  -- folding and indentation are native Neovim (0.11+) features; we start them
  -- per-buffer below. This replaces the old frozen `master` API
  -- (`require('nvim-treesitter.configs').setup{ highlight=..., indent=... }`),
  -- which no longer exists on `main`.
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Ensure the parsers we use are installed (async; a no-op once present).
    require('nvim-treesitter').install {
      'bash', 'c', 'cpp', 'css', 'csv', 'diff', 'dockerfile', 'git_config',
      'git_rebase', 'gitcommit', 'gitignore', 'go', 'html', 'http', 'ini',
      'javascript', 'json', 'lua', 'make', 'markdown', 'markdown_inline',
      'php', 'python', 'query', 'regex', 'requirements', 'rust', 'toml', 'tsx',
      'typescript', 'vim', 'vimdoc', 'yaml',
    }

    -- Native treesitter highlighting for any filetype that has a parser.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('nvim-treesitter-start', { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- NOTE: treesitter *indent* was enabled on the old master branch, but on `main`
    -- it is explicitly experimental and can mis-indent code, so it is intentionally
    -- left off here. To re-enable, add inside the FileType callback above:
    --   vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    -- Folding (also native) can be enabled similarly with:
    --   vim.wo[0][0].foldmethod = 'expr'
    --   vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
}
