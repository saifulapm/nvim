local colors = require('colors').load()

return {
  WhichKey = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  WhichKeyGroup = { foreground = colors.magenta },
  WhichKeyDesc = { foreground = colors.magenta },
  WhichKeySeparator = { foreground = colors.base5 },
  WhichKeyFloat = { background = colors.base2 },
  WhichKeyValue = { foreground = colors.grey },
}
