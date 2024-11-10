return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>cx",
      "<cmd>Trouble diagnostics<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp focus=false win.position=left<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    --[[
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    --]]
  },
}
