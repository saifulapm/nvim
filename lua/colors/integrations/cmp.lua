local colors = require('colors').load()
local utils = require 'utils.colors'

local faded = utils.Lighten(colors.bg_highlight, 0.30)

local cmp_hls = G.fold(
  function(accum, value, key)
    accum['CmpItemKind' .. key] = { link = value }
    return accum
  end,
  G.style.kinds,
  {
    CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
    CmpItemMenu = { foreground = faded, italic = true, bold = false },
    CmpItemAbbrMatch = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
    CmpItemAbbrDeprecated = { strikethrough = true, foreground = colors.fg_alt },
    CmpItemAbbrMatchFuzzy = {
      italic = true,
      foreground = G.style.ui.light_bg and colors.orange or colors.blue,
    },
  }
)

return cmp_hls
