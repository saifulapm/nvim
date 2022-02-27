local u = require('utils.color')
--
local tabline_bg = u.alter_color(u.get_hl('Normal', 'bg'), -16)

u.overwrite {
  { 'TabLineSel', {background = "Background", foreground = 'white', italic = true} },
  { 'TabLine', {background = tabline_bg, foreground = 'grey', } },
  { 'TabLineFill', {background = tabline_bg } },
}

require('buftabline').setup {
  tab_format = ' #{n}: #{b}#{f} #{i} ',
  auto_hide = true,
  go_to_maps = true,
}
