return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
    init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    }

    local select = require "nvim-treesitter-textobjects.select"
    local move = require "nvim-treesitter-textobjects.move"
    local swap = require "nvim-treesitter-textobjects.swap"

    local textobjects = {
      a = "parameter",
      b = "block",
      c = "class",
      f = "function",
      s = "statement",
    }

    for key, obj in pairs(textobjects) do
      local outer = "@" .. obj .. ".outer"
      local inner = "@" .. obj .. ".inner"

      -- Select
      vim.keymap.set({ "x", "o" }, "a" .. key, function() select.select_textobject(outer, "textobjects") end)
      vim.keymap.set({ "x", "o" }, "i" .. key, function() select.select_textobject(inner, "textobjects") end)

      -- Move: next start
      vim.keymap.set({ "n", "x", "o" }, "][" .. key, function() move.goto_next_start(outer, "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]" .. key, function() move.goto_next_start(outer, "textobjects") end)

      -- Move: next end
      vim.keymap.set({ "n", "x", "o" }, "]]" .. key, function() move.goto_next_end(outer, "textobjects") end)

      -- Move: previous start
      vim.keymap.set({ "n", "x", "o" }, "[[" .. key, function() move.goto_previous_start(outer, "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[" .. key, function() move.goto_previous_start(outer, "textobjects") end)

      -- Move: previous end
      vim.keymap.set({ "n", "x", "o" }, "[]" .. key, function() move.goto_previous_end(outer, "textobjects") end)
    end

    -- Swap
    vim.keymap.set("n", "<leader>a", function() swap.swap_next "@parameter.inner" end)
    vim.keymap.set("n", "<leader>A", function() swap.swap_previous "@parameter.inner" end)
  end,
}
