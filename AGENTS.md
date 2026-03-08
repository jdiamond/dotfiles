# Debugging Notes

## Check Neovim option values headlessly

```sh
nvim --headless -c 'set <option>?' -c 'qa' 2>&1
```

## Plugin install location (vim.pack)

`~/.local/share/nvim/site/pack/core/opt/`

## mini.nvim docs

`~/.local/share/nvim/site/pack/core/opt/mini.nvim/doc/`

e.g. `mini-ai.txt`, `mini-files.txt`, `mini-surround.txt` — read these directly instead of fetching from GitHub.

## Neovim runtime help docs

`~/.local/share/bob/nightly/share/nvim/runtime/doc/`

e.g. `lsp.txt`, `options.txt`, `lua.txt` — authoritative source for the installed version.
