# Neovim Config

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

| Dependency | Min version | Notes |
|---|---|---|
| [Neovim](https://neovim.io/) | 0.11+ | Uses `vim.lsp.Config` API |
| [Git](https://git-scm.com/) | any | lazy.nvim bootstrap |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | any | Telescope live grep |
| [fd](https://github.com/sharkdp/fd) | any | Telescope file search |
| [make](https://www.gnu.org/software/make/) | any | LuaSnip jsregexp build |
| A C compiler (`gcc` or `clang`) | any | nvim-treesitter parser compilation |
| [Node.js](https://nodejs.org/) | 18+ | JS/TS LSP servers |
| [lazygit](https://github.com/jesseduffield/lazygit) | any | lazygit.nvim |
| [direnv](https://direnv.net/) | any | direnv.vim |

```bash
# macOS (Homebrew)
brew install neovim git ripgrep fd lazygit direnv node
```

## Installation

```bash
git clone https://github.com/Victorinolavida/nvim-config ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on first launch and installs all plugins automatically.
After plugins install, Mason will auto-install LSP servers, formatters, and linters.

## Language Setup

### Go

**Required (install manually):**

```bash
# Go toolchain
brew install go   # or https://go.dev/dl/

# golangci-lint (Mason cannot install this one)
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh \
  | sh -s -- -b $(go env GOPATH)/bin v2.5.0

# golangci-lint language server
go install github.com/nametake/golangci-lint-langserver@latest
```

**Auto-installed by Mason:** `gopls`, `gofumpt`, `golines`, `goimports`, `staticcheck`, `delve`

**Debugging:** requires [delve](https://github.com/go-delve/delve) (installed via Mason).
On first debug run, `nvim-dap-go` will prompt to install the delve DAP adapter automatically.

### Python

**Required:**

```bash
pip install pyright black isort
```

Or use a virtual environment — `direnv` integration will pick it up automatically.

### TypeScript / JavaScript

Node.js is required (see Requirements). Mason handles the rest: `ts_ls`, `eslint`, `prettierd`, `prettier`.

### Lua

`lua_ls` and `stylua` are installed automatically via Mason.

### Java

`jdtls` is installed automatically via Mason. Uses [nvim-java](https://github.com/nvim-java/nvim-java) for a better experience.

### Rust

`rust_analyzer` is installed automatically via Mason.

---

## Key Bindings

`<leader>` = `Space`

### LSP (active in any language)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>wa` | Code actions |
| `<leader>D` | Type definition |
| `<leader>ws` | Workspace symbols |
| `<leader>wd` | Open diagnostics float |
| `[d` / `]d` | Previous / next diagnostic |
| `<C-s>` | Signature help (insert mode) |
| `<leader>F` | Format buffer |
| `<leader>zig` | Restart LSP |

### Go (active only in `.go` files)

| Key | Action |
|---|---|
| `<leader>gr` | `go run %` |
| `<leader>gt` | `go test ./...` |
| `<leader>gT` | `go test` current package |
| `<leader>gb` | `go build ./...` |
| `<leader>ga` | Alternate between `foo.go` ↔ `foo_test.go` |
| `<leader>ee` | Insert `if err != nil { return err }` |

### Debug (DAP)

**Delve is auto-installed by Mason** on first launch. No manual setup needed.

#### Workflow — debug a Go program

1. Open any `.go` file
2. Set a breakpoint: `<leader>db` on the target line
3. Start a session:
   - **Run current file:** `:lua require("dap-go").debug_test()` or use neotest (`<leader>dt`)
   - **Attach to running process:** `:lua require("dap").attach()`
   - **Re-run last session:** `<leader>dr`
4. DAP UI opens automatically — shows scopes, watches, call stack, console
5. Navigate with step keys below
6. Quit: `<leader>dq`

#### Workflow — debug a Go test

1. Open the `_test.go` file
2. Place cursor **inside** the test function you want to debug
3. `<leader>dt` — starts delve on that specific test
4. `<leader>dT` — re-runs the last debugged test (no cursor needed)

#### Variable inspection

- **Hover** over a variable while paused → `K` shows current value
- **Virtual text** appears automatically next to each line showing variable values (no keymap needed)
- **REPL / console** is in the DAP UI bottom panel — evaluate any expression

#### Conditional breakpoints & log points

- `<leader>dB` — breakpoint that only triggers when an expression is true  
  e.g. enter `i > 5` to pause only when `i` is greater than 5
- `<leader>dl` — log point: prints a message without pausing execution  
  e.g. enter `hit loop i={i}` to log without stopping

#### All keymaps

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompt for expression) |
| `<leader>dl` | Log point (prints, no pause) |
| `<leader>dc` | Continue / start session |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Re-run last session |
| `<leader>dR` | Restart current session |
| `<leader>dq` | Terminate session |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Debug nearest Go test (cursor inside test func) |
| `<leader>dT` | Re-run last debugged Go test |

### Navigation

| Key | Action |
|---|---|
| `<leader>pf` | Find/open project |
| `<C-h/j/k/l>` | Move between windows |
| `ss` / `sv` | Horizontal / vertical split |
| `te` | New tab |
| `<tab>` / `<S-tab>` | Next / previous tab |
| `<C-d>` / `<C-u>` | Page down / up (centered) |

### File Explorer (nvim-tree)

| Key | Action |
|---|---|
| `<leader>pv` | Toggle file explorer |
| `<C-]>` | Change session root to folder under cursor |
| `-` | Go up to parent directory |

> `<C-]>` and `-` change the entire session cwd (Telescope, LSP, etc. all scope to the new root) because `sync_root_with_cwd = true`.

### Telescope

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |

### Trouble (diagnostics)

| Key | Action |
|---|---|
| `<leader>tt` | Project diagnostics |
| `<leader>ts` | Document symbols |
| `<leader>tl` | LSP references/definitions |
| `<leader>tq` | Quickfix list |

### Git

| Key | Action |
|---|---|
| `<leader>lg` | Open lazygit |
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk (normal or visual) |
| `<leader>hr` | Reset hunk (normal or visual) |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>hu` | Undo last staged hunk |
| `<leader>hp` | Preview hunk inline |
| `<leader>hb` | Full blame for current line |
| `<leader>hd` | Diff this file |
| `<leader>gd` | Open diffview |
| `<leader>gh` | File git history |
| `<leader>gH` | Repo git history |
| `<leader>gx` | Close diffview |

### Neotest

| Key | Action |
|---|---|
| `<leader>nt` | Run nearest test |
| `<leader>nf` | Run all tests in file |
| `<leader>na` | Run entire test suite |
| `<leader>ns` | Stop running tests |
| `<leader>no` | Toggle output panel |
| `<leader>nS` | Toggle summary panel |

### Navigation (flash.nvim)

| Key | Action |
|---|---|
| `s` | Jump to any location (2-char label) |
| `S` | Treesitter-aware selection jump |
| `r` (operator-pending) | Remote flash (act on distant text object) |
| `R` (operator/visual) | Treesitter search jump |

### Terminal

| Key | Action |
|---|---|
| `<C-t>` | Toggle terminal (horizontal split) |
| `<leader>tf` | Toggle floating terminal |
| `<leader>th` | Toggle horizontal terminal |

### Editing

| Key | Action |
|---|---|
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>p` | Paste from system clipboard |
| `<leader>d` | Delete without yanking |
| `<leader>s` | Replace word under cursor (project-wide) |
| `K` / `J` (visual) | Move selection up / down |
| `<C-a>` | Select all |

---

## Plugin Highlights

| Category | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| Completion | blink.cmp + LuaSnip |
| LSP | mason.nvim + nvim-lspconfig |
| Formatting | conform.nvim |
| Syntax | nvim-treesitter |
| Fuzzy finder | telescope.nvim |
| Diagnostics | trouble.nvim + tiny-inline-diagnostic |
| Debugging | nvim-dap + nvim-dap-ui + nvim-dap-go + nvim-dap-virtual-text |
| Test runner | neotest + neotest-go |
| Git signs | gitsigns.nvim |
| Git diff/history | diffview.nvim |
| Navigation | flash.nvim |
| Auto pairs | nvim-autopairs |
| Status line | lualine.nvim |
| File explorer | nvim-tree |
| Git | lazygit (via snacks.nvim) |
| Navigation | harpoon + tekken.nvim |
| UI / indent / terminal | snacks.nvim |
| Theme | catppuccin (default), tokyonight, rose-pine, kanagawa |
