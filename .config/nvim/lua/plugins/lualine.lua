local qc = require('colors.quiet').colors

local a = 1
local b = 3
local c = 5

local theme = {
  insert = {
    a = { fg = qc.Normal[1], bg = qc.Warning[a], gui = 'bold' },
    b = { fg = qc.Normal[1], bg = qc.Warning[b] },
    c = { fg = qc.Normal[1], bg = qc.Warning[c] },
  },
  normal = {
    a = { fg = qc.Normal[1], bg = qc.Focus[a], gui = 'bold' },
    b = { fg = qc.Normal[1], bg = qc.Focus[b] },
    c = { fg = qc.Normal[1], bg = qc.Focus[c] },
  },
  inactive = {
    a = { fg = qc.Normal[3], bg = qc.Normal[6], gui = 'bold' },
    b = { fg = qc.Normal[3], bg = qc.Normal[6] },
    c = { fg = qc.Normal[3], bg = qc.Normal[6] },
  },
  visual = {
    a = { fg = qc.Normal[1], bg = qc.Info[a], gui = 'bold' },
    b = { fg = qc.Normal[1], bg = qc.Info[b] },
    c = { fg = qc.Normal[1], bg = qc.Info[c] },
  },
  replace = {
    a = { fg = qc.Normal[1], bg = qc.HighInterest[a], gui = 'bold' },
    b = { fg = qc.Normal[1], bg = qc.HighInterest[b] },
    c = { fg = qc.Normal[1], bg = qc.HighInterest[c] },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = { theme = theme },
  }
}
