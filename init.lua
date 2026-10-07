-- ==============================================================================
-- 1. CORE OPTIONS
-- Note: 'nocompatible', 'syntax on', 'filetype off/on', and 'encoding=UTF-8'
-- are omitted because Neovim handles them by default natively.
-- ==============================================================================
vim.opt.backup = false          -- Disable backup files
vim.opt.writebackup = false     -- Disable writebackup
vim.opt.cmdheight = 2           -- Give more space for displaying messages
vim.opt.tabstop = 1             -- Number of spaces that a <Tab> in the file counts for
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.opt.number = true           -- Print the line number

-- Plugin-specific global variables must be set before plugins are loaded
vim.g["airline#extensions#tabline#enabled"] = 1

-- ==============================================================================
-- 2. LAZY.NVIM BOOTSTRAP
-- ==============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==============================================================================
-- 3. PLUGIN DEFINITIONS
-- ==============================================================================
require("lazy").setup({
  { "neoclide/coc.nvim", branch = "release" },
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "preservim/nerdtree",
  "preservim/nerdcommenter",
  "jiangmiao/auto-pairs",
  "Xuyuanp/nerdtree-git-plugin",
  "gosukiwi/vim-atom-dark",
  "ap/vim-css-color",
  "junegunn/fzf.vim",
  "ryanoasis/vim-devicons",
  -- Note: You mapped a key to :FloatermToggle, but did not have the plugin
  -- installed in your old config. Uncomment the line below to install it.
  -- "voldikss/vim-floaterm",
})

-- ==============================================================================
-- 4. COLOR SCHEME
-- ==============================================================================
vim.cmd.colorscheme("atom-dark")

-- ==============================================================================
-- 5. KEY MAPPINGS
-- ==============================================================================
local map = vim.keymap.set

-- Buffer navigation
map("n", "<C-e>", ":bn<CR>", { noremap = true, silent = true })
map("n", "<C-j>", ":bp<CR>", { noremap = true, silent = true })
map("n", "<C-k>", ":bn<CR>", { noremap = true, silent = true })

-- Save file in insert mode and return to normal mode
map("i", "<C-S>", "<Esc>:update<CR>gi", { noremap = true, silent = true })

-- Quit Neovim forcefully
map("n", "<C-S-x>", ":qa!<CR>", { noremap = true, silent = true })

-- Plugin Toggles
map("n", "<F10>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
-- map("n", "<F12>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })

-- cycle windows
map("n", "<S-Tab>", "<C-w>w", { noremap = true, silent = true, desc = "Previous window" })

-- 1. Use Enter to SELECT the highlighted autocomplete option
vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { silent = true, noremap = true, expr = true, replace_keycodes = false })

-- 2. Use Ctrl+E to CANCEL/DISMISS the autocomplete menu without selecting
vim.keymap.set("i", "<C-e>", [[coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"]], { silent = true, noremap = true, expr = true, replace_keycodes = false })

-- ==============================================================================
-- 6. AUTOCOMMANDS (NERDTree Behavior)
-- ==============================================================================
local nerdtree_group = vim.api.nvim_create_augroup("NERDTreeBehavior", { clear = true })

-- Auto-open NERDTree on startup and put cursor back in the main window
vim.api.nvim_create_autocmd("VimEnter", {
  group = nerdtree_group,
  callback = function()
    vim.cmd("NERDTree | wincmd p")
  end,
})

-- Automatically close Neovim if NERDTree is the only window left open
vim.api.nvim_create_autocmd("WinEnter", {
  group = nerdtree_group,
  callback = function()
    if vim.fn.exists("t:NERDTreeBufName") == 1
       and vim.fn.bufwinnr(vim.t.NERDTreeBufName) ~= -1
       and vim.fn.winnr("$") == 1 then
      vim.cmd("q")
    end
  end,
})
