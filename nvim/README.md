# Neovim Config

## Requirements

- **Neovim 0.12+** — `vim.pack` (used for plugin loading) is a 0.12 API.

- **tree-sitter CLI** — required by nvim-treesitter to compile parsers. Note: this is `tree-sitter-cli`, not `tree-sitter` (which is just the library):
  ```sh
  brew install tree-sitter-cli
  ```

### LSP Servers

- **lua-language-server** — Lua/Neovim config:
  ```sh
  brew install lua-language-server
  ```

- **bash-language-server** — shell scripts (also requires `shellcheck` for diagnostics):
  ```sh
  brew install bash-language-server shellcheck
  ```

- **typescript-language-server** — JavaScript/TypeScript/JSX/TSX:
  ```sh
  npm install -g typescript-language-server typescript
  ```

## Debugging

### Check option values headlessly

```sh
nvim --headless -c 'set <option>?' -c 'qa' 2>&1
```

### Treesitter parsers recompiling on every startup

Symptoms: status line shows "Compiling parser" on startup; parsers like `rust` or `zsh` never finish installing.

1. Run `:checkhealth nvim-treesitter` — check for missing `tree-sitter` CLI and correct Neovim version.
2. Verify `tree-sitter` is on PATH: `which tree-sitter`
3. Verify you're running Neovim 0.12+: `nvim --version`
4. Check which parsers are missing their revision files:
   ```sh
   ls ~/.local/share/nvim/site/parser-info/
   ```
   Any parser listed in `init.lua` but absent here will be reinstalled every startup.
5. Manually install missing parsers headlessly:
   ```sh
   nvim --headless -c 'lua require("nvim-treesitter").install({"rust", "zsh"})' -c 'sleep 120' -c 'qa'
   ```

### Reference paths

- **Neovim runtime help docs:** `/opt/homebrew/share/nvim/runtime/doc/` (e.g. `lsp.txt`, `lua.txt`, `options.txt`)
- **Plugin install location (vim.pack):** `~/.local/share/nvim/site/pack/core/opt/`
- **mini.nvim docs:** `~/.local/share/nvim/site/pack/core/opt/mini.nvim/doc/` (e.g. `mini-ai.txt`, `mini-files.txt`, `mini-surround.txt`)
