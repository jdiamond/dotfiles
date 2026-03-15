-- Cache compiled Lua modules to speed up startup (improves require() calls by ~30%)
vim.loader.enable()

-- Run :TSUpdate whenever nvim-treesitter is updated
-- Must be before vim.pack.add() so it fires on lockfile-based installs too
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

-- Plugins
vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.nvim' },
  { src = 'https://github.com/catppuccin/nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
})

-- mini.basics: sets sensible defaults (number, wrap, signcolumn, splits, search, etc.)
-- Sets mapleader = " " if not already set
-- relnum_in_visual_mode: show relative numbers in visual mode only
require("mini.basics").setup({
  autocommands = { relnum_in_visual_mode = true },
})

-- Catppuccin theme
require("catppuccin").setup({
  flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces per indent/tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Single-line border on floating windows (hover, diagnostics, etc.)
vim.opt.winborder = "single"

-- Sync yank/paste with the OS clipboard
vim.opt.clipboard = "unnamedplus"

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

-- mini.diff: show added/modified/deleted lines in the sign column
require("mini.diff").setup({
  view = { style = 'sign' },
})

-- mini.git: git integration (branch status, inline blame, hunk operations)
require("mini.git").setup()

-- mini.pick: fuzzy finder for files, buffers, grep, etc.
require("mini.pick").setup()

-- mini.statusline: clean statusline
require("mini.statusline").setup()

-- mini.ai: extended text objects (viq for quotes, vif for function, etc.)
-- F = function definition (outer/inner) via treesitter-textobjects queries
require("mini.ai").setup({
  custom_textobjects = {
    F = require("mini.ai").gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
  },
})

-- mini.surround: add/delete/replace surrounding chars (sa", sd", sr"')
require("mini.surround").setup()

-- mini.comment: treesitter-aware comments (handles JSX {/* */} correctly)
require("mini.comment").setup()

-- mini.pairs: auto-close brackets and quotes
require("mini.pairs").setup()

-- mini.files: floating file explorer
require("mini.files").setup()

-- mini.jump2d: easymotion-style jump to visible spots via label filtering
-- <CR> to trigger, then type letters to filter down to target
require("mini.jump2d").setup()

-- LSP
-- vim.lsp.config() declares the server configuration. vim.lsp.enable() then
-- watches for matching filetypes and starts the server automatically.
-- Note: filetypes is required — without it, enable() doesn't know when to attach.
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      -- Tell lua_ls we're running LuaJIT (Neovim's Lua runtime)
      runtime = { version = 'LuaJIT' },
      workspace = {
        -- Expose Neovim's runtime files so lua_ls understands vim.* APIs
        library = vim.api.nvim_get_runtime_file("", true),
        -- Don't prompt to configure third-party library support
        checkThirdParty = false,
      },
    },
  },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash' },
})
vim.lsp.enable('bashls')

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})
vim.lsp.enable('ts_ls')

-- LspAttach fires when a language server connects to a buffer.
-- Keymaps are set here (not globally) so they only apply when LSP is active.
-- Using <leader>l ("language") namespace keeps LSP actions grouped and leaves
-- `gr` free for mini.operators (replace operator) if added later.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    -- Enable built-in LSP completion for this buffer (autotrigger = no manual <C-x><C-o> needed)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

    local b = { buffer = ev.buf }
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,      vim.tbl_extend('force', b, { desc = "Go to definition" }))
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,           vim.tbl_extend('force', b, { desc = "Show/focus hover docs" }))
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action,     vim.tbl_extend('force', b, { desc = "Actions" }))
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float,   vim.tbl_extend('force', b, { desc = "Diagnostic popup" }))
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,          vim.tbl_extend('force', b, { desc = "Format" }))
    vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover,           vim.tbl_extend('force', b, { desc = "Hover" }))
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation,  vim.tbl_extend('force', b, { desc = "Implementation" }))
    vim.keymap.set('n', '<leader>lR', vim.lsp.buf.references,      vim.tbl_extend('force', b, { desc = "References" }))
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename,          vim.tbl_extend('force', b, { desc = "Rename" }))
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.definition,      vim.tbl_extend('force', b, { desc = "Source definition" }))
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, vim.tbl_extend('force', b, { desc = "Type definition" }))
  end,
})

-- Keymaps

-- Save position before entering visual mode so <Esc> can restore it
local visual_start_pos = nil
local function save_pos_and_enter_visual(key)
  return function()
    -- Capture before feedkeys so position is saved before any text object moves the cursor
    visual_start_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys(key, 'n', false)
  end
end
local function exit_visual_and_restore_pos()
  local pos = visual_start_pos
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  -- Defer restore until after Neovim finishes processing the escape
  vim.schedule(function()
    if pos then vim.api.nvim_win_set_cursor(0, pos) end
  end)
end

vim.keymap.set('n', 'v',     save_pos_and_enter_visual('v'))
vim.keymap.set('n', 'V',     save_pos_and_enter_visual('V'))
vim.keymap.set('n', '<C-V>', save_pos_and_enter_visual(vim.api.nvim_replace_termcodes('<C-V>', true, false, true)))
vim.keymap.set('x', '<Esc>', exit_visual_and_restore_pos, { silent = true })

vim.keymap.set("n", "<leader>go", MiniDiff.toggle_overlay, { desc = "Toggle diff overlay" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>f", MiniPick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Grep" })
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Explorer" })

-- mini.clue: shows a popup of available keybindings after pausing on a prefix
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader key
    { mode = "n", keys = "<leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },
  clues = {
    { mode = 'n', keys = '<leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>l', desc = '+LSP' },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 500, -- milliseconds before popup appears
  },
})
