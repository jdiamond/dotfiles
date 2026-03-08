# Debugging Notes

## Check Neovim option values headlessly

```sh
nvim --headless -c 'set <option>?' -c 'qa' 2>&1
```

## Plugin install location (vim.pack)

`~/.local/share/nvim/site/pack/core/opt/`

## Neovim runtime help docs

`~/.local/share/bob/nightly/share/nvim/runtime/doc/`

e.g. `lsp.txt`, `options.txt`, `lua.txt` — authoritative source for the installed version.
