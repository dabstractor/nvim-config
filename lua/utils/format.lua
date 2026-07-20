-- Project-aware formatter resolution for conform.nvim.
--
-- Why this exists
-- ---------------
-- `formatters_by_ft` can be a *function* that conform evaluates at format
-- time. `stop_after_first = true` only picks the first *installed binary*, not
-- the first formatter whose project config exists -- so a static list cannot
-- express "use Biome inside Biome projects, Prettier everywhere else". This
-- module does that resolution explicitly by scanning the buffer's ancestor
-- directories for the config files each toolchain uses to *signal ownership*.
--
-- The contract for every resolver below:
--   * If the project declares a specific formatter  -> return that formatter.
--   * Otherwise                                      -> return the SAME list
--     this config always used (the "fallback"), so behavior is identical to
--     before in any project that hasn't opted into a different toolchain.

local M = {}

--- Nearest ancestor (inclusive) of the buffer's file containing any of
--- `markers`, or nil. Thin wrapper over `vim.fs.root` that guards unnamed
--- buffers.
--- @param bufnr integer
--- @param markers string[]
--- @return string|nil root
local function root(bufnr, markers)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  return vim.fs.root(name, markers)
end

--- True when any of `markers` exists at or above the buffer's location.
--- @param bufnr integer
--- @param markers string[]
local function has(bufnr, markers)
  return root(bufnr, markers) ~= nil
end

--- Read a file as text (best-effort). Used for cheap substring probing of
--- `[tool.x]` sections in pyproject.toml / the `prettier` key in package.json
--- without pulling in a TOML/JSON parser dependency.
--- @param path string
--- @return string|nil
local function read_text(path)
  local f = io.open(path, 'r')
  if not f then
    return nil
  end
  local s = f:read('*a')
  f:close()
  return s
end

--- True when a `[tool.<tool>` section appears in the nearest pyproject.toml at
--- or above the buffer. Matches `[tool.ruff]`, `[tool.ruff.format]`,
--- `[tool.black]`, `[tool.yapf]`, etc. The `tool` may contain dots.
--- @param bufnr integer
--- @param tool string
local function pyproject_has_tool(bufnr, tool)
  local r = root(bufnr, { 'pyproject.toml' })
  if not r then
    return false
  end
  local s = read_text(vim.fs.joinpath(r, 'pyproject.toml'))
  -- Plain literal search (plain=true): '[' and '.' are already literal, so we
  -- must NOT use '%' escapes here. Matches '[tool.ruff]', '[tool.ruff.format]',
  -- '[tool.black]', etc.
  return s ~= nil and s:find('[tool.' .. tool, 1, true) ~= nil
end

-- Config files each toolchain uses to signal "this project is mine". These
-- mirror the `cwd` detection conform's built-in formatter definitions already
-- perform, so we only redirect to a tool when the project actually owns it.
local MARKERS = {
  biome = { 'biome.json', 'biome.jsonc', '.biome.json', '.biome.jsonc' },
  dprint = { 'dprint.json', '.dprint.json', 'dprint.jsonc', '.dprint.jsonc' },
  deno = { 'deno.json', 'deno.jsonc', 'deno.lock' },
  prettier = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.mjs',
    '.prettierrc.ts',
    '.prettierrc.cts',
    '.prettierrc.mts',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs',
    'prettier.config.ts',
    'prettier.config.cts',
    'prettier.config.mts',
  },
  lua_format = { '.lua-format', 'lua-format.yml' },
  yamlfmt = { '.yamlfmt', 'yamlfmt.yaml', '.yamlfmt.yaml' },
  yamlfix = { '.yamlfix' },
  yapf = { '.style.yapf' },
}

-- Fallbacks -- byte-for-byte the lists this config used before project-aware
-- resolution. Resolvers return these when no project-specific tool is found.
local FALLBACK = {
  -- `stop_after_first = true` = "use the first available formatter, ignore the
  -- rest". prettierd (daemon) is preferred, falling back to the plain CLI.
  prettier = { 'prettierd', 'prettier', stop_after_first = true },
  -- JSON also gets `jq` as a last resort (jq is JSON-only, hence jsonc omits it).
  json = { 'prettierd', 'prettier', 'jq', stop_after_first = true },
  python = { 'isort', 'black' }, -- runs isort, then black, sequentially
  lua = { 'stylua' }, -- stylua auto-detects .stylua.toml
  -- yamlfmt AND yamlfix, run sequentially (preserves prior behavior).
  yaml = { 'yamlfmt', 'yamlfix' },
}

-- Biome formats a *subset* of the web family. It errors on html/markdown/yaml,
-- so only redirect to Biome for the languages it actually supports.
-- (Source: https://biomejs.dev/internals/language-support/)
local BIOME_FILETYPES = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  json = true,
  jsonc = true,
  css = true,
  scss = true,
  less = true,
  graphql = true,
}

--- Does the project declare a Prettier config, including the `prettier` key in
--- package.json? Mirrors prettierd's own root resolution.
--- @param bufnr integer
local function has_prettier_config(bufnr)
  if has(bufnr, MARKERS.prettier) then
    return true
  end
  local r = root(bufnr, { 'package.json' })
  if not r then
    return false
  end
  local s = read_text(vim.fs.joinpath(r, 'package.json'))
  -- `"prettier":` (with optional whitespace before the colon).
  return s ~= nil and s:find('"prettier"%s*:', 1) ~= nil
end

--- Core resolver for the JS/web family. Checks the opinionated project signals
--- (Biome -> dprint -> Deno), else returns the caller's fallback.
--- @param bufnr integer
--- @param fallback string[]
--- @return string[]
local function web(bufnr, fallback)
  local ft = vim.bo[bufnr].filetype
  -- Biome: only for the languages it can format (skip for html/markdown/yaml).
  if BIOME_FILETYPES[ft] and has(bufnr, MARKERS.biome) then
    return { 'biome', stop_after_first = true }
  end
  -- dprint: plugin-driven, so we trust a present dprint.json for any language.
  if has(bufnr, MARKERS.dprint) then
    return { 'dprint', stop_after_first = true }
  end
  -- Deno projects: deno_fmt covers the full web + markdown + yaml set.
  if has(bufnr, MARKERS.deno) then
    return { 'deno_fmt', stop_after_first = true }
  end
  return fallback
end

-- Public resolvers (one per conform `formatters_by_ft` entry that needs them).

M.web = function(bufnr)
  return web(bufnr, FALLBACK.prettier)
end

-- JSON gets its own entry so the no-config fallback can include `jq`.
M.json = function(bufnr)
  return web(bufnr, FALLBACK.json)
end

M.python = function(bufnr)
  -- Ruff: dedicated config, or an explicit [tool.ruff.format] section. We key
  -- off the *format* section (not bare [tool.ruff]) so projects that use Ruff
  -- for linting only -- and Black for formatting -- keep using isort+black.
  if has(bufnr, { 'ruff.toml', '.ruff.toml' }) or pyproject_has_tool(bufnr, 'ruff.format') then
    return { 'ruff_organize_imports', 'ruff_format' }
  end
  -- YAPF: explicit config.
  if has(bufnr, MARKERS.yapf) or pyproject_has_tool(bufnr, 'yapf') then
    return { 'yapf' }
  end
  return FALLBACK.python
end

M.lua = function(bufnr)
  -- stylua is this config's standard (and auto-detects .stylua.toml). Only
  -- redirect when a project explicitly declares LuaFormatter config.
  if has(bufnr, MARKERS.lua_format) then
    return { 'lua-format', stop_after_first = true }
  end
  return FALLBACK.lua
end

M.yaml = function(bufnr)
  if has(bufnr, MARKERS.yamlfmt) then
    return { 'yamlfmt', stop_after_first = true }
  end
  if has(bufnr, MARKERS.yamlfix) or pyproject_has_tool(bufnr, 'yamlfix') then
    return { 'yamlfix', stop_after_first = true }
  end
  if has_prettier_config(bufnr) then
    return { 'prettierd', 'prettier', stop_after_first = true }
  end
  return FALLBACK.yaml
end

return M