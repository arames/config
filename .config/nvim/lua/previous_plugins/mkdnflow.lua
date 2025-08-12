vim.keymap.set({'n'}, '<Leader>ww', ":vsp ~/work/wiki/README.md<CR>")
vim.keymap.set({'n'}, '<Leader><Enter>', ":MkdnToggleToDo<CR>")

return {
  "jakewvincent/mkdnflow.nvim",
  opts= {
    perspective = {
      priority = 'current'
    },
    links = {
      transform_explicit = function(text)
        return text
      end
    }
  }
}

