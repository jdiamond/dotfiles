# Debugging Notes

## Check Neovim option values headlessly

```sh
nvim --headless -c 'set <option>?' -c 'qa' 2>&1
```

## Plugin install location (vim.pack)

`~/.local/share/nvim/site/pack/core/opt/`
