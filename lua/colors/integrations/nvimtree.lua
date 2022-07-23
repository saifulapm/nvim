local colors = require('colors').load()

return {
  NvimTreeFolderName = {
    foreground = G.style.ui.light_bg and colors.base9 or colors.blue,
    bold = true,
  },
  NvimTreeRootFolder = { foreground = colors.green },
  NvimTreeEmptyFolderName = { foreground = colors.fg_alt, bold = true },
  NvimTreeSymlink = { foreground = colors.fg, underline = true },
  NvimTreeExecFile = { foreground = colors.green, bold = true },
  NvimTreeImageFile = { foreground = G.style.ui.light_bg and colors.orange or colors.blue },
  NvimTreeOpenedFile = { foreground = colors.fg_alt },
  NvimTreeSpecialFile = { foreground = colors.fg, underline = true },
  NvimTreeMarkdownFile = { foreground = colors.fg, underline = true },
  NvimTreeGitDirty = { link = 'DiffModifiedGutter' },
  NvimTreeGitStaged = { link = 'DiffModifiedGutter' },
  NvimTreeGitMerge = { link = 'DiffModifiedGutter' },
  NvimTreeGitRenamed = { link = 'DiffModifiedGutter' },
  NvimTreeGitNew = { link = 'DiffAddedGutter' },
  NvimTreeGitDeleted = { link = 'DiffRemovedGutter' },
  NvimTreeIndentMarker = { link = 'IndentGuide' },
  NvimTreeOpenedFolderName = { link = 'NvimTreeFolderName' },
}
