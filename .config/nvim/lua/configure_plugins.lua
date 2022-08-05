local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'shada_plugin',
  'tar',
  'tarPlugin',
  'zip',
  'zipPlugin',
}

for i = 1, #disabled_built_ins do
  vim.g['loaded_' .. disabled_built_ins[i]] = 1
end

-- Plugin configurations requiring a particular config order.
require('config.cmp-nvim-lsp')
require('config.nvim_lspconfig')
require('config.nvim-autopairs')

-- Plugin configurations not caring about the order.
require('config.colorizer')
require('config.hop')
require('config.leap')
require('config.lualine')
require('config.mkdnflow')
require('config.telescope')
require('config.treesitter')
require('config.vim-vsnip')
