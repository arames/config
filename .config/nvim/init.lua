-- init.lua
-- by Alexandre Rames <alexandre.rames@gmail.com>
--
-- The configuration is targeted at and has only been tested on terminal nvim.

vim.opt.ignorecase = true         -- Ignore case in search by default,
vim.opt.smartcase = true          -- but be case sensitive when using uppercase.
vim.opt.wildmode = "longest:full,full" -- Complete longest common string, then list.
vim.opt.wildoptions = "fuzzy,pum"

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Presentation ============================================================{{{1

vim.opt.termguicolors = true              -- Use gui colors in the terminal.
vim.opt.winminheight = 0               -- Minimum size of splits is 0.
vim.opt.wrap = false                   -- Do not wrap lines.
vim.opt.scrolloff = 5                  -- Show at least 5 lines around the cursor.
vim.opt.showbreak = vim.fn.nr2char(8618) .. " " -- Show ↪ at the beginning of wrapped lines.

vim.opt.foldlevelstart = 99            -- Start editing with all folds open.

vim.opt.number = true                  -- Display line numbers.

vim.opt.cursorline = true              -- Highlight the line number...
vim.opt.cursorlineopt = "number"       -- ...for the current line.

-- Load/Save and Automatic Backup =========================================={{{1

-- Backup files.
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/nvim/backup//"
-- Keep a history of the edits so changes from a previous session can be
-- undone.
vim.opt.undofile = true
-- Automatically save and load views.
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWrite" }, {
  pattern = "*",
  command = "silent! mkview"
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  command = "silent! loadview"
})

-- Editing ================================================================={{{1

-- Turn off last search highlighting
vim.keymap.set("n", "<Leader><Space>", ":nohlsearch<CR>", { silent = true })

-- Move between splits.
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

-- We want editing to be fast even with large/huge files. On those,
-- filetype-specific plugins can take a long time, so turn off the filetype.
vim.g.large_file_size = 4 * 1024 * 1024
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("<afile>"))
    if file_size > vim.g.large_file_size or file_size == -2 then
      -- Disable features triggered by the filetype event, including syntax
      -- highlighting.
      vim.opt.eventignore:append("FileType")
      -- Save memory when another file is viewed.
      vim.opt_local.bufhidden = "unload"
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("echohl WarningMsg")
          vim.api.nvim_echo({
            { "Warning: this file is larger than "
              .. (vim.g.large_file_size / 1024 / 1024)
              .. " MB, so some options are modified (see init.lua for details).",
              "WarningMsg" }
          }, true, {})
          vim.cmd("echohl None")
        end
      })
    end
  end
})

-- Handle custom file types.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.mlir",
  command = "set filetype=mlir"
})
-- `.inc` files are generated via LLVM tblgen.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.cpp.inc",
  command = "set filetype=cpp"
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.h.inc",
  command = "set filetype=cpp"
})

-- Completion =========================================={{{2

-- Display a menu, insert the longest common prefix but don't select the first
-- entry, and display some additional information if available.
vim.opt.completeopt = "menu,menuone,noselect,longest,fuzzy"
-- `<C-l>` acts as the key to start completion and accept completion.
vim.keymap.set("i", "<C-l>", function()
  if vim.fn.pumvisible() == 1 then
    local info = vim.fn.complete_info()
    if info.selected < 0 then
      return "<C-n><C-y>"
    else
      return "<C-y>"
    end
  else
    return "<C-x><C-o>"
  end
end, { expr = true })
-- Map `<C-j>` and `<C-k>` to `Down` and `Up` when the popup menu is visible.
vim.keymap.set("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-j>"
end, { expr = true })
vim.keymap.set("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-k>"
end, { expr = true })


-- Indentation ========================================={{{2

-- Recognize numbered lists and indent them nicely.
vim.opt.formatoptions:append("n")

vim.api.nvim_create_user_command("IndentTab", function()
  vim.opt.expandtab = false
  vim.opt.shiftwidth = 8
  vim.opt.tabstop = 8
  vim.opt.cinoptions = "(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4"
end, {})

vim.api.nvim_create_user_command("IndentGoogle", function()
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.cinoptions = "(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4"
end, {})

vim.api.nvim_create_user_command("IndentLinuxKernel", function()
  vim.opt.expandtab = false
  vim.opt.shiftwidth = 8
  vim.opt.tabstop = 8
  vim.opt.cinoptions = "(0,w1,i4,W4,l1,g1,h1,N-s,t0,:0,+4"
end, {})

vim.api.nvim_create_user_command("IndentLLVM", function()
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.cinoptions = "(0,w1,i4,W4,l1,g0,h2,N-s,t0,:0,+4"
end, {})

vim.cmd("IndentLLVM") -- Default to LLVM-style indentation.

-- Command line ============================================================{{{1

-- Pressing shift-; takes too much time!
vim.keymap.set("n", ";", ":", { noremap = true })

-- Command-line shortcuts that expand to the path of the current file.
vim.cmd([[
  cabbr <expr> %% fnameescape(expand("%:h"))
  cabbr <expr> $$ fnameescape(expand("%"))
  cabbr <expr> %%f fnameescape(expand("%:hp"))
  cabbr <expr> $$f fnameescape(expand("%:p"))
]])

-- Make <C-n> and <C-p> take the beginning of the line into account.
vim.keymap.set("c", "<C-p>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true })
vim.keymap.set("c", "<C-n>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
-- `<C-l>` triggers completion and accepts completion.
vim.keymap.set("c", "<C-l>", function()
  if vim.fn.pumvisible() == 1 then
    -- Accept the current selection by inserting then deleting a space.
    return "<Space><BS>"
  else
    -- Trigger wildmenu completion.
    return "<C-z>"
  end
end, { expr = true })
-- And `<C-j>` and `<C-k>` can be used to navigate.
vim.keymap.set("c", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true })
vim.keymap.set("c", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true })

-- Plugins =================================================================={{{1

require("config.lazy")

-- nvim: set foldmethod=marker:
