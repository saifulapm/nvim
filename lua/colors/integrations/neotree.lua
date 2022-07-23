local colors = require('colors').load()

return {
  NeoTreeIndentMarker = { link = 'Comment' },
  NeoTreeNormal = { link = 'PanelBackground' },
  NeoTreeNormalNC = { link = 'PanelBackground' },
  NeoTreeRootName = { bold = true, italic = true, foreground = 'LightMagenta' },
  NeoTreeCursorLine = { link = 'Visual' },
  NeoTreeStatusLine = { link = 'PanelSt' },
  NeoTreeTabBackground = { link = 'PanelDarkBackground' },
  NeoTreeTab = { background = { from = 'PanelDarkBackground' }, foreground = colors.fg_alt },
  NeoTreeSeparator = { link = 'PanelDarkBackground' },
  NeoTreeActiveTab = { background = { from = 'PanelBackground' }, foreground = 'fg', bold = true },
}
