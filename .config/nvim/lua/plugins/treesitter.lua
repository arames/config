return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  --dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  version = false, -- last release is way too old and doesn't work on Windows
  enable = true,
  build = ":TSUpdate",
  --[[
  LazyVim exposes special events. We emulate with simple ones.
  event = { "LazyFile", "VeryLazy" },
  --]]
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  opts_extend = { "ensure_installed" },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "diff",
      "gitcommit",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "regex",
      "rust",
      "tablegen",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
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
        -- 'a' is easier to type than 'p', so assume it is "argument" instead
        -- of "parameter".
        swap_next = { ["<leader>a"] = "@parameter.inner", },
        swap_previous = { ["<leader>A"] = "@parameter.inner", },
      },
    },
  },
  ---@param opts TSConfig
  config = function(_, opts)
    -- TODO: if type(opts.ensure_installed) == "table" then
    -- TODO:   opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
    -- TODO: end
    require("nvim-treesitter.configs").setup(opts)
  end,
}

