local colors = require('quiet').colors

local a = 1
local b = 3
local c = 5

return {
  insert = {
    a = {fg = colors.normal[1], bg = colors.focus[a], gui = 'bold'},
    b = {fg = colors.normal[1], bg = colors.focus[b]},
    c = {fg = colors.normal[1], bg = colors.focus[c]},
 },
  normal = {
    a = {fg = colors.normal[1], bg = colors.warning[a], gui = 'bold'},
    b = {fg = colors.normal[1], bg = colors.warning[b]},
    c = {fg = colors.normal[1], bg = colors.warning[c]},
 },
  inactive = {
    a = {fg = colors.normal[3], bg = colors.normal[6], gui = 'bold'},
    b = {fg = colors.normal[3], bg = colors.normal[6]},
    c = {fg = colors.normal[3], bg = colors.normal[6]},
 },
  visual = {
    a = {fg = colors.normal[1], bg = colors.info[a], gui = 'bold'},
    b = {fg = colors.normal[1], bg = colors.info[b]},
    c = {fg = colors.normal[1], bg = colors.info[c]},
 },
  replace = {
    a = {fg = colors.normal[1], bg = colors.high_interest[a], gui = 'bold'},
    b = {fg = colors.normal[1], bg = colors.high_interest[b]},
    c = {fg = colors.normal[1], bg = colors.high_interest[c]},
 },
}
