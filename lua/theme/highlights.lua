local cmd = vim.cmd
local theme = require("theme")
local colors = theme.get()

local black = colors.black
local black2 = colors.black2
local blue = colors.blue
local darker_black = colors.darker_black
local folder_bg = colors.folder_bg
local green = colors.green
local grey = colors.grey
local grey_fg = colors.grey_fg
local line = colors.line
local nord_blue = colors.nord_blue
local one_bg = colors.one_bg
local one_bg2 = colors.one_bg2
local pmenu_bg = colors.pmenu_bg
local purple = colors.purple
local red = colors.red
local white = colors.white
local yellow = colors.yellow
local orange = colors.orange

local lsp = {
  error = red,
  warn = orange,
  hint = yellow,
  info = nord_blue,
}
local hint_line = theme.alter_color(lsp.hint, -80)
local error_line = theme.alter_color(lsp.error, -80)
local warn_line = theme.alter_color(lsp.warn, -80)
local info_line = theme.alter_color(lsp.info, -80)

local ui = require("utils").load_config().ui

-- Define bg color
-- @param group Group
-- @param color Color
local function bg(group, color)
   cmd("hi " .. group .. " guibg=" .. color)
end

-- Define fg color
-- @param group Group
-- @param color Color
local function fg(group, color)
   cmd("hi " .. group .. " guifg=" .. color)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
local function fg_bg(group, fgcol, bgcol)
   cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

local function link(group, link_group)
  cmd('hi! link ' .. group .. ' ' .. link_group)
end

-- Comments
if ui.italic_comments then
   fg("Comment", grey_fg .. " gui=italic")
else
   fg("Comment", grey_fg)
end

-- Disable cusror line
cmd "hi clear CursorLine"

-- Line number
fg("cursorlinenr", white)

-- same it bg, so it doesn't appear
fg("EndOfBuffer", black)

-- For floating windows
fg("FloatBorder", blue)

link("NormalFloat", "Normal")

-- Pmenu
bg("Pmenu", one_bg)
bg("PmenuSbar", one_bg2)
bg("PmenuSel", pmenu_bg)
bg("PmenuThumb", nord_blue)

-- misc
fg("LineNr", grey)

fg("NvimInternalError", red)

-- inactive statuslines as thin splitlines
fg("StatusLineNC", one_bg2 .. " gui=underline")
fg("VertSplit", one_bg2)
-- fg_bg("Visual",light_grey, colors.lightbg)

if ui.transparency then
   bg("Normal", "NONE")
   bg("Folded", "NONE")
   fg("Folded", "NONE")
   fg("Comment", grey)
end

-- [[ Plugin Highlights

-- Dashboard
fg("DashboardCenter", grey_fg)
fg("DashboardFooter", grey_fg)
fg("DashboardHeader", grey_fg)
fg("DashboardShortcut", grey_fg)

-- Git signs
fg_bg("DiffAdd", green, "none")
fg_bg("DiffChange", purple, "none")
fg_bg("DiffDelete", red, "none")

-- Indent blankline plugin
fg("IndentBlanklineChar", line)

-- ]]

-----------------------------------------------------------------------------//
-- Treesitter
-----------------------------------------------------------------------------//
link('TSError', 'LspDiagnosticsUnderlineError')
-- highlight FIXME comments
fg('commentTSWarning', red .. " gui=bold" )
fg('commentTSDanger', yellow .. " gui=bold")
-----------------------------------------------------------------------------//

-- LSP
-----------------------------------------------------------------------------//
-- avoid the urge to be "clever" and try and programmatically set these because
-- 1. the name are slightly different (more than just the prefix) i.e. Warn -> Warning
-- 2. Some plugins have not migrated so having both highlight groups is valuable
fg('LspReferenceText', "NONE" .. " gui=underline")
fg('LspReferenceRead', "NONE" .. " gui=underline")
fg('DiagnosticHint', lsp.hint )
fg('DiagnosticError', lsp.error )
fg('DiagnosticWarning', lsp.warn )
fg('DiagnosticInfo', lsp.info )
fg('DiagnosticUnderlineError', "NONE" .. " gui=undercurl" .. " guisp=" .. lsp.error )
fg('DiagnosticUnderlineHint', "NONE" .. " gui=undercurl" .. " guisp=" .. lsp.hint )
fg('DiagnosticUnderlineWarn', "NONE" .. " gui=undercurl" .. " guisp=" .. lsp.warn )
fg('DiagnosticUnderlineInfo', "NONE" .. " gui=undercurl" .. " guisp=" .. lsp.info )
bg('DiagnosticSignHintLine', hint_line )
bg('DiagnosticSignErrorLine', error_line )
bg('DiagnosticSignWarnLine', warn_line )
bg('DiagnosticSignInfoLine', info_line )
link('DiagnosticSignWarn', 'DiagnosticWarn')
link('DiagnosticSignInfo', 'DiagnosticInfo')
link('DiagnosticSignHint', 'DiagnosticHint')
link('DiagnosticSignError', 'DiagnosticError')
link('DiagnosticFloatingWarn', 'DiagnosticWarn')
link('DiagnosticFloatingInfo', 'DiagnosticInfo')
link('DiagnosticFloatingHint', 'DiagnosticHint')
link('DiagnosticFloatingError', 'DiagnosticError')
-- TODO: delete the following when v0.6 is stable
fg('LspDiagnosticsSignHint', lsp.hint )
fg('LspDiagnosticsDefaultHint', lsp.hint )
fg('LspDiagnosticsDefaultError', lsp.error )
fg('LspDiagnosticsDefaultWarning', lsp.warn )
fg('LspDiagnosticsDefaultInformation', lsp.info )
bg('LspDiagnosticsSignHintLine', hint_line )
bg('LspDiagnosticsSignErrorLine', error_line )
bg('LspDiagnosticsSignWarningLine', warn_line )
bg('LspDiagnosticsSignInformationLine', info_line )
fg('LspDiagnosticsUnderlineError', "NONE" .. " gui=undercurl" .. " guisp=lsp.error")
fg('LspDiagnosticsUnderlineHint', "NONE" .. " gui=undercurl" .. " guisp=lsp.hint")
fg('LspDiagnosticsUnderlineWarning', "NONE" .. " gui=undercurl" .. " guisp='orange'")
fg('LspDiagnosticsUnderlineInformation', "NONE" .. " gui=undercurl" .. " guisp=lsp.info")

-- ]]

-- TODO Comments
bg('TodoSignFIX', 'NONE')
bg('TodoSignTODO', 'NONE')
bg('TodoSignNOTE', 'NONE')
bg('TodoSignWARN', 'NONE')
bg('TodoSignPERF', 'NONE')
bg('TodoSignHACK', 'NONE')

-- NvimTree
fg("NvimTreeEmptyFolderName", blue)
fg("NvimTreeEndOfBuffer", darker_black)
fg("NvimTreeFolderIcon", folder_bg)
fg("NvimTreeFolderName", folder_bg)
fg("NvimTreeGitDirty", red)
fg("NvimTreeIndentMarker", one_bg2)
bg("NvimTreeNormal", darker_black)
bg("NvimTreeStatusLine", darker_black)
fg("NvimTreeOpenedFolderName", blue)
fg("NvimTreeRootFolder", red .. " gui=underline") -- enable underline for root folder in nvim tree
fg_bg("NvimTreeStatuslineNc", darker_black, darker_black)
fg("NvimTreeVertSplit", darker_black)
bg("NvimTreeVertSplit", darker_black)
fg_bg("NvimTreeWindowPicker", red, black2)

-- Disable some highlight in nvim tree if transparency enabled
if ui.transparency then
   bg("NvimTreeNormal", "NONE")
   bg("NvimTreeStatusLineNC", "NONE")
   bg("NvimTreeVertSplit", "NONE")
   fg("NvimTreeVertSplit", grey)
end

-- Telescope
fg("TelescopeBorder", line)
fg("TelescopePreviewBorder", grey)
fg("TelescopePromptBorder", line)
fg("TelescopeResultsBorder", line)

-- Whitespace
fg("ExtraWhitespace", red)
