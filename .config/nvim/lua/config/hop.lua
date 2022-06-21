 local map = vim.api.nvim_set_keymap

 require('hop').setup()
 map('', ']w', '<cmd>HopWord<CR>', {noremap = true})
 map('', '[w', '<cmd>HopWord<CR>', {noremap = true})
 map('', ']l', '<cmd>HopLineStart<CR>', {noremap = true})
 map('', '[l', '<cmd>HopLineStart<CR>', {noremap = true})
