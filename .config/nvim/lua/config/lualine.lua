local navic = require("nvim-navic")

local theme = require'config.lualine-quiet'

require("lualine").setup({
  options = {theme = theme},
  sections = {
    lualine_c = {
      'filename',
      {navic.get_location, cond = navic.is_available},
    }
  }
})
