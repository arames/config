return {
  "arames/vim-diffgofile",
  config = function()
    vim.g.diffgofile_goto_existing_buffer = 1
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "diff", "git" },
      callback = function()
        vim.keymap.set("n", "<C-]>", ":call DiffGoFile('n')<CR>", { buffer = true })
        vim.keymap.set("n", "<C-v><C-]>", ":call DiffGoFile('v')<CR>", { buffer = true })
      end,
    })
  end,
}
