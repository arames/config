return {
  "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>fa", "<cmd>Telescope find_files<cr>", desc = "Find files (all files)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>ff", "<cmd>Telescope git_files<cr>", desc = "Find files (git-files)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-f>"] = actions.preview_scrolling_down,
          },
        },
        path_display = {"truncate"}
      },
      pickers = { colorscheme = { enable_preview = true } },
    }
  end
}

