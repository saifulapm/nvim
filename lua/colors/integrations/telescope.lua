local colors = require('colors').load()

return {
  TelescopeSelection = { foreground = colors.yellow, bold = true },
  TelescopeSelectionCaret = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopeMultiSelection = { foreground = colors.grey },
  TelescopeNormal = { foreground = colors.fg },
  TelescopeMatching = { foreground = colors.green, bold = true },
  TelescopePromptPrefix = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopeBorder = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopePromptBorder = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopeResultsBorder = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopePreviewBorder = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  TelescopePrompt = { link = 'TelescopeNormal' },
}
