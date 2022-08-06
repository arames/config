local colors = {
  normal = {'#cccccc'},
  focus = {'#339933'},
  interest = {'#bb8855'},
  high_interest = {'#cc2244'},
  info = {'#5599cc'},
  warning = {'#bb7c00'},
  error = {'#cc0000'},
}


function string_from_table(o)
   if type(o) == 'table' then
      local s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '  ['..k..'] = ' .. string_from_table(v) .. ',\n'
      end
      return s .. '}'
   else
      return tostring(o)
   end
end


function print_colors(colors)
  for color_name, color_string_table in pairs(colors) do
    print(color_name)
    for _, color in pairs(color_string_table) do
      print(color)
    end
  end
end


function color_from_string(color_string)
  return {r = tonumber(string.sub(color_string, 2, 3), 16),
          g = tonumber(string.sub(color_string, 4, 5), 16),
          b = tonumber(string.sub(color_string, 6, 7), 16)}
end


function hex_str(c)
  return string.format("%02x", c)
end


function string_from_color(color)
  return '#' .. hex_str(color.r) .. hex_str(color.g) .. hex_str(color.b)
end


--[[
function compute_luminance(color)
  -- Multiple formula were suggested. I found this one to give the best results
  -- for the colors I tested.
  return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b
  --return 0.299  * color.r + 0.587  * color.g + 0.114  * color.b
  --return math.sqrt(0.299 * color.r^2 + 0.587 * color.g^2 + 0.114 * color.b^2)
end


function update_luminance(color, target_luminance)
  local luminance = compute_luminance(color)
  local factor = target_luminance / luminance
  local updated_color = {r = math.min(math.max(math.floor(color.r * factor), 0), 255),
                         g = math.min(math.max(math.floor(color.g * factor), 0), 255),
                         b = math.min(math.max(math.floor(color.b * factor), 0), 255)}
  return updated_color
end

local target_luminance = compute_luminance(color_from_string(colors.focus[1]))
for color_name, color_string_table in pairs(colors) do
  local color = color_from_string(color_string_table[1])
  local target_color = update_luminance(color, target_luminance)
  local diff = {r = color.r and (math.abs(target_color.r - color.r) / color.r) or 0,
                g = color.g and (math.abs(target_color.g - color.g) / color.g) or 0,
                b = color.b and (math.abs(target_color.b - color.b) / color.b) or 0}
  local threshold = 0.05
  if diff.r > threshold or diff.g > threshold or diff.b > threshold then
    print('The luminance diff for color ' .. color_name .. ' is ' .. string_from_table(diff) .. '.')
    print('The recommended color is ' .. string_from_color(target_color) .. '.')
  end
end
--]]


function scale_color(color, n)
  decrement = {r = math.floor(color.r / n),
               g = math.floor(color.g / n),
               b = math.floor(color.b / n)}

  scale = {}
  for i=1,n,1 do
    scale[i] = {r = color.r - (i - 1) * decrement.r,
                g = color.g - (i - 1) * decrement.g,
                b = color.b - (i - 1) * decrement.b}
  end
  return scale
end


for color_name, color_table in pairs(colors) do
  assert(#color_table == 1)
  local color_string = color_table[1]
  local color = color_from_string(color_string)
  local scaled_colors = scale_color(color, 6)
  for index, scaled_color in ipairs(scaled_colors) do
    colors[color_name][index] = string_from_color(scaled_color)
  end
    
end

--print_colors(colors)
--[[
warning
#bb7c00
#9c6800
#7d5400
#5e4000
#3f2c00
#201800
error
#cc0000
#aa0000
#880000
#660000
#440000
#220000
normal
#cccccc
#aaaaaa
#888888
#666666
#444444
#222222
focus
#339933
#2b802b
#236723
#1b4e1b
#133513
#0b1c0b
info
#5599cc
#4780aa
#396788
#2b4e66
#1d3544
#0f1c22
high_interest
#cc2244
#aa1d39
#88182e
#661323
#440e18
#22090d
interest
#bb8855
#9c7247
#7d5c39
#5e462b
#3f301d
#201a0f
]]

return {colors = colors}
