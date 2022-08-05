--require('leap').set_default_keymaps()

vim.keymap.set(
  {'n', 'x', 'o'},
  '<Plug>(leap-window)',
  function() require'leap'.leap {target_windows = {vim.api.nvim_get_current_win()}} end,
  {silent = true})
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-window)', {silent = true})
