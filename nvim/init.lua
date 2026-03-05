-- Plugins
vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.nvim' },
})

-- Leader key (must be set before keymaps)
vim.g.mapleader = " "

-- Show line numbers
vim.opt.number = true

-- Show line numbers relative to cursor (helps with jump commands like 5j)
vim.opt.relativenumber = true

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces per indent level
vim.opt.shiftwidth = 2

-- Number of spaces a tab character appears as
vim.opt.tabstop = 2

-- Automatically indent new lines based on context
vim.opt.smartindent = true

-- Don't wrap long lines
vim.opt.wrap = false

-- Enable 24-bit color (required for most color schemes)
vim.opt.termguicolors = true

-- Always show the sign column (prevents layout shift when diagnostics appear)
vim.opt.signcolumn = "yes"

-- Faster cursor hold events (used by LSP for hover, diagnostics, etc.)
vim.opt.updatetime = 250

-- Open vertical splits to the right
vim.opt.splitright = true

-- Open horizontal splits below
vim.opt.splitbelow = true

-- Keep some lines visible above/below cursor when scrolling
vim.opt.scrolloff = 8

-- Ignore case when searching...
vim.opt.ignorecase = true

-- ...unless the search contains uppercase letters
vim.opt.smartcase = true

-- Highlight all search matches as you type
vim.opt.hlsearch = true

-- Show search matches incrementally as you type
vim.opt.incsearch = true

-- Single global statusline (prevents duplicate statusline from mini.pick)
vim.opt.laststatus = 3

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
