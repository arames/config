return {
  "nvimdev/indentmini.nvim",
  config = function()
    require("indentmini").setup()
    vim.api.nvim_set_hl(0, "IndentLine", { link = "LowInterest" })
    vim.api.nvim_set_hl(0, "IndentLineCurrent", { link = "Interest" })
  end,
}
