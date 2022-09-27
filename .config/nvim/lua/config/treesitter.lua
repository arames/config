-- TODO:
-- * Set up incremental selection: https://github.com/nvim-treesitter/nvim-treesitter#available-modules
-- * Ensure treesitter is only loaded for supported filetypes?

require('nvim-treesitter.configs').setup {
  -- Ensure support for these languages is installed.
  ensure_installed = { 'c', 'cpp', 'python', 'lua' },
  sync_install = true,

  highlight = { enable = true, },
  indent = {
    enable = true,
    disable = {"python"}
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["as"] = "@statement.outer",
        ["is"] = "@statement.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      --[[
      -- mapping : direction (start|end)? obj_type
      -- direction: previous | next
      -- previous: [
      -- next: ]
      -- start: [
      -- end: ]
      --
      -- When (start|end) is omitted, we use implicitly the start.
      --]]
      goto_next_start = {
        ["][a"] = "@parameter.outer",
        ["][b"] = "@block.outer",
        ["][c"] = "@class.outer",
        ["][f"] = "@function.outer",
        ["][s"] = "@statement.outer",
        ["]a"] = "@parameter.outer",
        ["]b"] = "@block.outer",
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
        ["]s"] = "@statement.outer",
      },
      goto_next_end = {
        ["]]a"] = "@parameter.outer",
        ["]]b"] = "@block.outer",
        ["]]c"] = "@class.outer",
        ["]]f"] = "@function.outer",
        ["]]s"] = "@statement.outer",
      },
      goto_previous_start = {
        ["[[a"] = "@parameter.outer",
        ["[[b"] = "@block.outer",
        ["[[c"] = "@class.outer",
        ["[[f"] = "@function.outer",
        ["[[s"] = "@statement.outer",
        ["[a"] = "@parameter.outer",
        ["[b"] = "@block.outer",
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
        ["[s"] = "@statement.outer",
      },
      goto_previous_end = {
        ["[]a"] = "@parameter.outer",
        ["[]b"] = "@block.outer",
        ["[]c"] = "@class.outer",
        ["[]f"] = "@function.outer",
        ["[]s"] = "@statement.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner", },
      swap_previous = { ["<leader>A"] = "@parameter.inner", },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "+",
      scope_incremental = "grc",
      node_decremental = "-",
    },
  },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
