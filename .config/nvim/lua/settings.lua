local cmd = vim.cmd
local map = vim.api.nvim_set_keymap
local opt = vim.opt
local wopt = vim.wo

-- Global Settings ---------------------------------------------------------{{{1

vim.g.mapleader = ","

opt.encoding = 'utf-8'
opt.history=10000              -- Keep 10000 lines of command line history.
opt.mouse = 'a'                -- Enable the mouse (eg. for resizing).
opt.ignorecase = true          -- Ignore case in search by default,
opt.smartcase = true           -- but be case sensitive when using uppercase.
opt.wildmenu = true            -- Command-line completion in an enhanced mode.
opt.wildmode = 'list:longest'  -- Complete longest common string, then list.
opt.showcmd = true             -- Show currently inputed command.
opt.errorbells = false         -- No bells.

-- Load/save and automatic backup ------------------------------------------{{{1

opt.backupdir = vim.fn.stdpath('config') .. '/tmp/backup'
opt.directory = vim.fn.stdpath('config') .. '/tmp/swap'
opt.undodir = vim.fn.stdpath('config') .. '/tmp/undo'
opt.viewdir = vim.fn.stdpath('config') .. '/tmp/view'

opt.backup = true              -- Backup files.
opt.autoread = true            -- Automatically reload files changed on the disk.
opt.autowrite = true           -- Write a modified buffer on each :next , ...
opt.undofile = true            -- Keep a history of edits so changes from a
                               -- previous session can be undone.

-- Automatically save and load views.
vim.api.nvim_create_autocmd({'BufWinLeave'}, {
  callback = function() cmd [[silent! mkview]] end,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function() cmd [[silent! loadview]] end,
})


-- Disable some settings for large files ================{{{2
--local large_size = 10 * 1024 * 1024
--large_files_callbacks = {}
--table.insert(large_files_callbacks, function()
--  file_size = cmd [[let file_size = getfsize(expand('<afile>'))]]
--  print('disabling swap files on large file ' .. file_size)
--  print(file_size)
--  vim.bo.bufhidden = 'unload'
--  vim.bo.swapfile = false
--  vim.bo.undolevels = 100
--end)
--vim.api.nvim_create_augroup('large_files_settings', { clear = true })
--vim.api.nvim_clear_autocmds{group = 'large_files_settings'}
--vim.api.nvim_create_autocmd('BufReadPre', {
--    callback = function(bufnr)
--      for _, large_file_callback in pairs(large_files_callbacks) do
--        large_file_callback(bufnr)
--      end
--    end,
--    group = 'large_files_settings',
--    desc = 'Disable some settings to speed up editing of large files.'
--})


-- Presentation ------------------------------------------------------------{{{1

opt.termguicolors = true       -- Use GUI colors in the terminal.
cmd [[colorscheme quiet]]
opt.winminheight = 0           -- Minimum size of splits is 0.

wopt.wrap = false              -- Do not wrap lines.
opt.scrolloff = 5              -- Show at least 5 lines around the cursor.


opt.number = true              -- Display line numbers.
-- The use of relative line numbering is deprecated, in favor of using `HopLine`
-- and `tree-sitter` motions.

-- Editing -----------------------------------------------------------------{{{1

opt.hlsearch = true             -- Highlight the last used search pattern.
opt.showmatch = true            -- Briefly display matching bracket.
opt.matchtime = 5               -- Time (*0.1s) to show matching bracket.
opt.incsearch = true            -- Perform incremental searching.
opt.inccommand = 'split'        -- Show incremental results of substitute.
map('n', '<Space>', ':nohlsearch<CR>', {})

-- Move between splits.
map('n', '<C-h>', '<C-w>h', {noremap = true})
map('n', '<C-j>', '<C-w>j', {noremap = true})
map('n', '<C-k>', '<C-w>k', {noremap = true})
map('n', '<C-l>', '<C-w>l', {noremap = true})

-- TODO: set completeopt=menu,menuone,noselect

-- Automatically strip the comment marker when joining automated lines.
--set formatoptions+=j
-- Recognize numbered lists and indent them nicely.
--set formatoptions+=n

-- Command line ------------------------------------------------------------{{{1

-- Pressing shift-; takes too much time!
map('', ';', ':', {noremap = true })
-- But the ';' key to re-execute the latest find command is useful
map('', '-', ';', {noremap = true })
map('', '_', ',', {noremap = true })

-- `$$` expands to the path of the current file.
-- `%%` expands to the path of the directory containing the current file.
cmd [[cabbr <expr> %% fnameescape(expand('%:p:h'))]]
cmd [[cabbr <expr> $$ fnameescape(expand('%:p'))]]

-- Make <C-N> and <C-P> take the beginning of the line into account.
cmd [[cnoremap <C-n> <Down>]]
cmd [[cnoremap <C-p> <Up>]]

-- .vimrc specific options -------------------------------------------------{{{1
-- vim: set foldmethod=marker:
-- nvim: set foldmethod=marker:
