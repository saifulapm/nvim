local u = require 'utils.color'
local P = G.style.doom

u.overwrite {
  { 'TabLineSel', { background = 'Background', foreground = P.teal, italic = true, bold = false } },
  { 'TabLine', { background = 'Background', foreground = 'None' } },
  { 'TabLineFill', { background = 'Background', foreground = P.comment_grey, bold = false } },
}

require('buftabline').setup {
  tab_format = ' #{n}: #{b}#{f} #{i} ',
  auto_hide = true,
  go_to_maps = true,
}
