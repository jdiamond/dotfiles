-- Plugins
vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
})

-- mini.basics: sets sensible defaults (number, wrap, signcolumn, splits, search, etc.)
-- Sets mapleader = " " if not already set
-- relnum_in_visual_mode: show relative numbers in visual mode only
require("mini.basics").setup({
  autocommands = { relnum_in_visual_mode = true },
})

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces per indent/tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Faster cursor hold events (used by LSP for hover, diagnostics, etc.)
vim.opt.updatetime = 250

-- Keep some lines visible above/below cursor when scrolling
vim.opt.scrolloff = 8

-- Single global statusline (prevents duplicate statusline from mini.pick)
vim.opt.laststatus = 3

-- Start with all folds open (tree-sitter folding would otherwise fold on open)
vim.opt.foldlevel = 99

-- nvim-treesitter: install parsers for languages we use
-- Parser names don't always match filetypes (e.g. "bash" parser, but "sh" filetype)
require("nvim-treesitter").install({ "lua", "javascript", "typescript", "rust", "python", "bash", "zsh", "json", "yaml", "markdown" })

-- Enable tree-sitter features per filetype
-- This runs whenever a file is opened matching one of these filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "rust", "python", "bash", "sh", "zsh", "json", "yaml", "markdown" },
  callback = function()
    -- Syntax highlighting: replaces regex-based highlighting with AST-based highlighting
    -- pcall catches errors if the parser isn't ready yet (e.g. on first install)
    local ok = pcall(vim.treesitter.start)
    if not ok then return end
    -- Folding: use tree-sitter to fold by syntax structure instead of indentation
    -- foldmethod=expr means "use foldexpr to compute fold boundaries"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
    -- Indentation: use tree-sitter to compute indent for new lines (e.g. after pressing enter)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- mini.pick: fuzzy finder for files, buffers, grep, etc.
require("mini.pick").setup()

-- mini.statusline: clean statusline
require("mini.statusline").setup()

-- Keymaps
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>f", MiniPick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Grep" })

-- mini.clue: shows a popup of available keybindings after pausing on a prefix
require("mini.clue").setup({
  triggers = {
    { mode = "n", keys = "<leader>" },
  },
  clues = {
    { mode = "n", keys = "<leader>q", desc = "Quit" },
    { mode = "n", keys = "<leader>f", desc = "Find files" },
    { mode = "n", keys = "<leader>/", desc = "Grep" },
  },
  window = {
    delay = 200, -- milliseconds before popup appears
  },
})
