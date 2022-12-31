-- Plugin configurations requiring a particular config order.
require('config.cmp-nvim-lsp')
require('config.nvim_lspconfig')
require('config.nvim-autopairs')

-- Plugin configurations not caring about the order.
require('config.treesitter')
require('config.vim-vsnip')
