-- TODO:
-- * Set up incremental selection: https://github.com/nvim-treesitter/nvim-treesitter#available-modules
-- * Ensure treesitter is only loaded for supported filetypes?

require('nvim-treesitter.configs').setup {
  -- Ensure support for these languages is installed.
  ensure_installed = { 'c', 'cpp', 'python', 'lua' },
  sync_install = true,

  highlight = { enable = true, },
  indent = { enable = true, },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
        ["[a"] = "@parameter.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner", },
      swap_previous = { ["<leader>A"] = "@parameter.inner", },
    },
  },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
