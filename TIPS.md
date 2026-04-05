# Tips

Random tips for tools I use daily. View a random tip with `tip` or `tip <tool>`.

---

## Neovim

### `]]` and `[[` jump between functions and headers
Uses treesitter-textobjects. Works for functions/classes in code, and headers in markdown. Jump forward with `]]`, backward with `[[`.

### `K` shows hover documentation
Press once to show hover popup, press `K` again to focus it, press `q` to close. Or just navigate away to dismiss.

### `gd` jumps to definition
Go to definition under cursor. Use `<C-o>` to jump back.

### `<leader>l` is the LSP namespace
LSP actions: `<leader>la` for code actions, `<leader>lr` for rename, `<leader>lf` for format, `<leader>ld` for diagnostics, `<leader>ls` for source definition.

### `\` prefix reveals toggles
Thanks to mini.clue, pausing after `\` shows available toggles: `\b` (background), `\c` (cursor column), `\u` (undo history), `\w` (wrap).

### `v`, `V`, `C-v` then `<Esc>` returns to original position
Custom mapping saves position before entering visual mode (any variant). Useful when you just want to peek at a selection.

### `<CR>` triggers mini.jump2d
Press Enter, then type letters to jump to any visible spot. Easymotion-style navigation.

### mini.surround operators
`sa` add (e.g., `saiw"` surrounds word with quotes), `sd` delete (e.g., `sd"` removes quotes), `sr` replace (e.g., `sr"'` changes quotes to single).

### mini.ai custom textobjects
`vif` / `viF` for inner/outer function, `viq` for inner quote (works with any quote type).

### `<C-x>` triggers builtin completion
In insert mode, `<C-x>` pauses to show completion sources: `<C-x><C-f>` for files, `<C-x><C-l>` for lines, etc. mini.clue shows options.

### `<leader>go` toggles diff overlay
Shows full diff in a floating window. Useful for seeing all changes at once vs. the sign column.

### `<leader>ph` runs health check
Use `:checkhealth vim.pack` to diagnose plugin issues, `:checkhealth` for general health.

### `ZZ` saves and quits, `ZQ` quits without saving
`ZZ` is `:wq`, `ZQ` is `:q!`. Fewer keystrokes than typing the colon commands.

### `go` / `gO` add empty lines
Like `o`/`O` but stays in normal mode. Useful when you just want spacing without typing.

### `gV` selects last changed/yanked text
Visually select what you just changed or yanked. Handy for reusing or inspecting recent edits.

### `<C-s>` saves the file
From mini.basics. Works in normal and insert mode.

### `<leader>` is space
The `mini.basics` setup sets leader to space if not already set. Easier to type than `\` or `,`.

### `<leader>b` picks buffers, `<C-^>` toggles alternate
`<leader>b` opens mini.pick's buffer picker. `<C-^>` (Ctrl+6) toggles between current and alternate buffer — faster than the picker for two-buffer switching.

### `:vert help <topic>` opens help in vertical split
By default `:help` splits horizontally, pushing your code down. Use `:vert help` to keep it side-by-side.

### `<C-w>o` maximizes the current window
Makes the current window the only one. No undo — other windows are closed, not hidden. Buffers remain, use `<C-^>` to switch back.

### `:ls!` shows unlisted buffers
Help buffers and plugin scratch buffers are unlisted by default. `:ls` only shows listed buffers; `:ls!` shows everything including help files.

### Buffer = content, Window = viewport
A buffer is file content in memory. A window is a viewport onto a buffer. One buffer can appear in multiple windows. Closing a window doesn't delete its buffer.

### Sync `vim.pack` plugins to lockfile
`vim.pack.update(nil, { target = 'lockfile' })` installs plugins at the revision specified in `nvim-pack-lock.json` — like `npm ci` for Neovim plugins. Use after pulling lockfile changes from another machine.

### `:InspectTree` shows treesitter parse tree
Opens a vertical split with the full syntax tree. Press `a` to toggle anonymous nodes, `I` for source language, `o` for query editor. Jump to nodes with Enter.

### Check filetype with `:set filetype?`
Shows the current buffer's filetype. Useful when debugging why treesitter or ftplugins aren't working as expected.

### Buffer-local mappings override global ones
Filetypes like `nvim-pack` define their own `]]`/`[[` mappings that take precedence over your treesitter textobjects. Check the ftplugin source in `$VIMRUNTIME/ftplugin/` when mappings behave unexpectedly.

---

## Yazi

### `s` and `S` search with fd and rg
`s` searches filenames with fd, `S` searches file contents with rg. Use `/` for incremental search within the current directory.

### `h` navigates to parent from search results
After searching, pressing `h` on a file takes you to its containing directory. Parent navigation works everywhere in yazi.

### `T` toggles preview pane
Custom plugin. Hide the preview to see more files, or show it when needed.

### `M` maximizes preview pane
Custom plugin. Temporarily gives preview the full width. Press `M` again to restore.

### `~` shows help, `f` filters
Press `~` to see all keybindings, then `f` to filter/search within help.

### `z` and `Z` switch directories from within yazi
`z` opens an fzf picker for directories. `Z` opens a zoxide picker using its frecency database.

### `y` wrapper changes shell directory
The `y()` function writes yazi's exit directory to a temp file and `cd`'s to it. Note: quitting with `Q` skips this. If you unintentionally changed directories, use `-` to go back.

---

## Zsh

### `Ctrl-X Ctrl-E` edits command line
Opens current command in `$EDITOR`. Useful for crafting complex commands or fixing long ones.

### `z` jumps by frecency, `zi` picks interactively
`z proj` jumps to your project directory. `zi` opens an fzf picker to select from your directory history.

### `-` returns to previous directory
The `-` alias runs `cd -`. Quick way to toggle between two directories.

### television fuzzer
`Ctrl-T` finds files, `Ctrl-R` searches command history.

### `ll` uses eza with all flags
`-a` shows hidden files, `-l` is long format. Git-aware modern `ls`.

---

## Lazygit

### Press `?` for keybindings
Shows all available commands for the current panel. Useful since lazygit has many context-dependent keys.

### `e` to edit file
Opens the selected file in `$EDITOR`. For conflicts, opens both versions.

### `c` commits staged changes
After staging files with `a` or space, `c` opens the commit message dialog.

### `/` searches
In the files panel, searches filenames. In commits panel, searches commit messages.
