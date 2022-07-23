local colors = require('colors').load()

return {

  -- Diff
  diffLine = { foreground = colors.base8, background = colors.diff_info_bg1 },
  diffSubName = { foreground = colors.base8, background = colors.diff_info_bg1 },

  DiffAdd = { background = colors.diff_add_bg1 },
  DiffChange = { background = colors.diff_add_bg1 },
  DiffText = { background = colors.diff_add_bg0 },
  DiffDelete = { background = colors.gh_danger_bg0 },

  DiffAdded = { foreground = colors.diff_add_fg0, background = colors.diff_add_bg1 },
  DiffModified = { foreground = colors.fg, background = colors.diff_info_bg0 },
  DiffRemoved = { foreground = colors.gh_danger_fg0, background = colors.gh_danger_bg1 },

  DiffAddedGutter = { foreground = colors.diff_add_fg, bold = true },
  DiffModifiedGutter = { foreground = colors.diff_info_fg, bold = true },
  DiffRemovedGutter = { foreground = colors.gh_danger_fg, bold = true },

  DiffAddedGutterLineNr = { foreground = colors.grey },
  DiffModifiedGutterLineNr = { foreground = colors.grey },
  DiffRemovedGutterLineNr = { foreground = colors.grey },

  GitGutterAdd = { link = 'DiffAddedGutter' },
  GitGutterChange = { link = 'DiffModifiedGutter' },
  GitGutterDelete = { link = 'DiffRemovedGutter' },
  GitGutterChangeDelete = { link = 'DiffModifiedGutter' },
  GitGutterAddLineNr = { link = 'DiffAddedGutterLineNr' },
  GitGutterChangeLineNr = { link = 'DiffModifiedGutterLineNr' },
  GitGutterDeleteLineNr = { link = 'DiffRemovedGutterLineNr' },
  GitGutterChangeDeleteLineNr = { link = 'DiffModifiedGutterLineNr' },

  GitSignsAddLn = { link = 'DiffAddedGutter' },
  GitSignsAddInline = { link = 'DiffAddedGutter' },
  GitSignsAddLnInline = { link = 'DiffAddedGutter' },
  GitSignsChangeLn = { link = 'DiffModifiedGutter' },
  GitSignsDeleteInline = { link = 'DiffRemovedGutter' },
  GitSignsDeleteLn = { link = 'DiffRemovedGutter' },
  GitSignsChangeDelete = { link = 'DiffModifiedGutter' },
}
