local u = require 'utils.color'
u.overwrite {
  { 'TroubleNormal', { link = 'PanelBackground' } },
  { 'TroubleText', { link = 'PanelBackground' } },
  { 'TroubleIndent', { link = 'PanelVertSplit' } },
  { 'TroubleFoldIcon', { foreground = 'yellow', bold = true } },
  { 'TroubleLocation', { foreground = u.get_hl('Comment', 'fg') } },
}

require('trouble').setup {
  -- position = "right",
}
