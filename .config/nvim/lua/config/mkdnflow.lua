require('mkdnflow').setup({
  perspective = {
    priority = 'current'
    },
  links = {
    transform_explicit = function(text)
      return text
    end
    }
})
vim.keymap.set({'n'}, '<Leader>ww', ":vsp ~/work/wiki/README.md<CR>")
