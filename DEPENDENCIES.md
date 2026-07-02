# External Dependencies

Everything this Neovim config needs **outside** of Neovim itself and the plugins
(`:Lazy`/Mason handle plugins). Mason auto-installs most language tooling, so the
list of things you must install at the OS level is short.

> **Neovim requirement: 0.12.0+** (this config uses `nvim-treesitter` `main`,
> native `vim.treesitter`, native commenting, and native LSP APIs that need 0.11/0.12).
> Verified on **0.12.3**.

---

## 1. Hard requirements (install at OS level)

These are needed for the editor to build/run at all. Almost all are already
present on this machine.

| Tool | Why | Status |
|---|---|---|
| **git** | lazy.nvim fetches plugins; fugitive/neogit/gitsigns | ✅ |
| **make** + **C compiler** (`gcc`/`cc`) | build `telescope-fzf-native`, treesitter parsers, various plugin `build` steps | ✅ |
| **unzip** | lazy.nvim, Mason unpacking | ✅ |
| **curl** + **tar** | `nvim-treesitter` `main` downloads/builds parsers | ✅ |
| **`tree-sitter` CLI ≥ 0.26.1** | `nvim-treesitter` `main` builds parsers from source (`tree-sitter generate`) | ✅ `~/.local/bin/tree-sitter` (0.26.10) |
| **Node.js + npm** | Mason installs many tools via npm; also windsurf/mcphub | ✅ node 26 / npm 11 |
| **ripgrep (`rg`)** | Telescope `live_grep`/`grep_string`, fzf, search | ✅ (via cargo) |
| **A Nerd Font** | icons everywhere (nvim-web-devicons, statusline, trees) | ✅ JetBrainsMono Nerd Font (set in `lua/user/font.lua`) |

> `rg` is the actual binary name — `command -v ripgrep` is empty but `rg` is on PATH. Fine.

Install (Debian/Ubuntu) if missing:
```sh
sudo apt install git build-essential unzip curl tar ripgrep
# tree-sitter CLI (prebuilt binary; don't use the npm one):
curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
  -o /tmp/ts.gz && gunzip -f /tmp/ts.gz && install -m755 /tmp/tree-sitter ~/.local/bin/tree-sitter
```

---

## 2. Mason-managed tooling (auto-installed — you do NOT install these manually)

`mason-tool-installer` and `mason-lspconfig`/`mason-nvim-dap` provision these into
`~/.local/share/nvim/mason/`. They are kept in sync on startup. Currently installed:

**LSP servers** (`lua/lsp.lua`):
`gopls` · `pyright` · `rust_analyzer` · `phpactor` · `openscad_lsp` · `eslint` (eslint-lsp) · `lua_ls` · `yamlls`

> **TypeScript/JavaScript is NOT an LSP here** — it's handled by `pmizio/typescript-tools.nvim`,
> which uses the project's `tsserver` (from `node_modules` or a global `typescript` npm pkg).
> Make sure your TS projects have `typescript` installed, or `npm i -g typescript`.

**Formatters/linters** (`mason-tool-installer` ensure_installed in `lua/lsp.lua`):
`stylua` · `yamlfmt` · `prettierd` · `prettier` · `eslint-lsp` · `markdownlint`

(conform.nvim also references `isort`, `black`, `jq`, `yamlfix`, `openscad-lsp` —
`jq` is system-level, the rest are Mason-managed and installed on first format.)

**DAP debug adapter** (`mason-nvim-dap` ensure_installed in `lua/plugins/dap.lua`):
`delve` (Go)

---

## 3. Per-feature external tools

Install only what you use.

### Searching / fuzzy find
- **`fzf`** — used by `fzf-lua`/`fzf.vim`. ✅ present. (Telescope itself does not need fzf — it uses `telescope-fzf-native`, built by `make`.)

### Git
- **`lazygit`** — `<leader>lg` / `:LazyGit`. ✅
- **`lazydocker`** — `<leader>ld` / `:LazyDocker`. ✅

### HTTP / REST clients
- **`hurl`** — `hurl.nvim` (`<leader>ha` run request). ✅
- **`jq`** — JSON formatting for hurl/rest output. ✅
- `tidy` — *optional*, rest.nvim HTML pretty-printing. ❌ not installed (hurl covers HTML via prettier). Install: `sudo apt install tidy`.

### Debugging (`lua/plugins/dap.lua`)
- **`gdb`** — C/C++ debugging (`dap.adapters.gdb`). ✅
- **`node`** — JS/TS/PHP debug adapters run under node. ✅
- **Go**: `delve` is Mason-managed (above). ✅ (`go` itself: ✅)
- ⚠️ **Node debug adapters are configured but currently broken** — `dap.lua` points
  `vscode-chrome-debug`, `vscode-firefox-debug`, `vscode-node-debug2`, `vscode-php-debug`
  at `vim.g.dap_home` (`~/src/`) and the `pwa-node` adapter has empty args. These
  paths don't exist on this machine. JS/TS browser/node debugging will not work until
  you install the relevant vscode-debug adapters into `~/src/` (or we clean up `dap.lua`
  — flagged in `MODERNIZATION-ANALYSIS.md` §7.7).

### Markdown
- **`markdownlint`** — Mason-managed (above). ✅ (just installed)
- **A web browser** — `markdown-preview.nvim` opens previews in your browser.

### AI tooling (terminal agents are the primary workflow; these are in-editor)
- **`ccr`** (claude-code-router) — `codecompanion`'s default `ccr` adapter runs
  `ccr start` (`lua/plugins/codecompanion.lua`). Install per its repo if you use in-editor chat.
- **`claude-code`** CLI — the `claude_code` adapter (you're removing claude-code.nvim in Phase 2).
- **`aider`** CLI (python) — `nvim-aider` (being removed in Phase 2).
- **Windsurf** (replacing codeium, Phase 4) — `windsurf.vim`; authenticate via `:Codeium Auth`.
- **`mcp-hub`** (npm global) — `mcphub.nvim` runs an MCP server (`npm install -g mcp-hub@latest`). Optional; only for in-editor MCP agents.

### File handling
- **`rip`** — safe-delete used by `:DeleteCurrentFile` (`rip % || rm %`). ✅ (via cargo)
- **`sad`** — *optional*, project-wide find/replace helper (listed in README; not currently wired to a keymap). ❌ not installed. Install: `cargo install sad` if wanted.

### Session / clipboard / GUI
- **`xclip`/`xsel`/`wl-copy`** — system clipboard (`+` register). Ensure one is present for `<C-c>`/copy to work.
- **Neovide** — optional GUI (better keymap support; the config special-cases it in `lua/neovide.lua`). ✅ present.

---

## 4. Language toolchains (only for languages you actually edit)

Mason downloads the *servers*, but the language runtimes themselves are yours:

| Language | Need | Status |
|---|---|---|
| Go | `go` (gopls + delve are Mason) | ✅ |
| Python | `python3` (pyright/isort/black are Mason) | ✅ |
| Rust | `rustc`/`cargo` (rust-analyzer is Mason) | check: `rustc --version` |
| PHP | `php`/`composer` (phpactor is Mason) | check if used |
| Lua | (lua_ls is Mason; no runtime needed for config editing) | ✅ |
| OpenSCAD | `openscad` binary (openscad-lsp + openscad.nvim) | check if used |

---

## 5. Currently-missing optional tools (only install if you use the feature)

- `tidy` — rest.nvim HTML formatting (hurl is the alternative)
- `sad` — README-listed find/replace CLI (not currently keybound)
- Node vscode-debug adapters under `~/src/` — needed only for JS/TS browser/node **debugging** (and `dap.lua` needs cleanup first)

Everything *required* for normal editing is already installed.

---

## 6. Secrets / env vars

- **`Z_AI_API_KEY_NVIM`** — in `~/.secrets.sh` (sourced by `~/.config/zsh/.zshrc`).
  Powers `minuet-ai.nvim` inline completion against z.ai's coding endpoint
  (`https://api.z.ai/api/coding/paas/v4`). Isolated from your shared `Z_AI_API_KEY`.
- **`NVIM_AUTOSAVE=1`** — opt-in autosave (e.g. `alias onvim='NVIM_AUTOSAVE=1 nvim'`).

---

## Maintenance notes

- **Mason tools**: managed automatically. Run `:Mason` to inspect/upgrade;
  `:checkhealth` reports missing ones.
- **tree-sitter CLI**: must stay ≥ 0.26.1 and on PATH for `:TSUpdate`/parser installs
  (nvim-treesitter `main` branch). It lives in `~/.local/bin` (not tracked by this repo).
- **After a fresh clone**: open nvim once → Mason/lazy install everything →
  `:TSUpdate` → `:MasonToolsInstall` → restart.
