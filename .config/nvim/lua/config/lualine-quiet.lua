local colors = {
  focus   = '#339933',
  color1   = '#99c794',
  color2   = '#65737e',
  color3   = '#343d46',
  color4   = '#5599cc',
  color5   = '#d8dee9',
  color6   = '#f99157',
  color7   = '#ec5f67',
}

--[[
Using coolors.co with base colors and 4 steps down for each darker color.
--]]

return {
  insert = {
    a = {fg = '#cccccc', bg = '#339933', gui = 'bold'},
    b = {fg = '#cccccc', bg = '#1f5c1f'},
    c = {fg = '#cccccc', bg = '#0a1f0a'},
 },
  normal = {
    a = {fg = '#cccccc', bg = '#cd8800', gui = 'bold'},
    b = {fg = '#cccccc', bg = '#7a5200'},
    c = {fg = '#cccccc', bg = '#291b00'},
 },
  inactive = {
    a = {fg = '#777777', bg = '#222222', gui = 'bold'},
    b = {fg = '#777777', bg = '#222222'},
    c = {fg = '#777777', bg = '#222222'},
 },
  visual = {
    a = {fg = '#cccccc', bg = '#3377bb', gui = 'bold'},
    b = {fg = '#cccccc', bg = '#235280'},
    c = {fg = '#cccccc', bg = '#122940'},
 },
  replace = {
    a = {fg = '#cccccc', bg = '#cc2244', gui = 'bold'},
    b = {fg = '#cccccc', bg = '#8c182f'},
    c = {fg = '#cccccc', bg = '#460c17'},
 },
}
