local u = require 'utils.color'
local P = G.style.doom
local L = {
  error = P.pale_red,
  warn = P.dark_orange,
  hint = P.bright_yellow,
  info = P.teal,
}
local bg_color = u.alter_color(u.get_hl('Normal', 'bg'), -16)
local M = {}

local general_heightlight = function()
  local comment_fg = u.get_hl('Comment', 'fg')
  local keyword_fg = u.get_hl('Keyword', 'fg')
  local search_bg = u.get_hl('Search', 'bg')
  local normal_bg = u.get_hl('Normal', 'bg')
  local code_block = u.alter_color(normal_bg, 30)
  -- local msg_area_bg = u.alter_color(normal_bg, -10)
  local msg_area_bg = 'NONE'
  local hint_line = u.alter_color(L.hint, -80)
  local error_line = u.alter_color(L.error, -80)
  local warn_line = u.alter_color(L.warn, -80)
  local info_line = u.alter_color(L.info, -80)

  u.overwrite {
    { 'mkdLineBreak', { link = 'NONE' } },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    { 'MsgArea', { background = msg_area_bg } },
    { 'MsgSeparator', { foreground = comment_fg, background = msg_area_bg } },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    { 'NormalFloat', { inherit = 'Pmenu' } },
    { 'FloatBorder', { inherit = 'NormalFloat', foreground = u.get_hl('NonText', 'fg') } },
    { 'CodeBlock', { background = code_block } },
    { 'markdownCode', { background = code_block } },
    { 'markdownCodeBlock', { background = code_block } },
    --- Highlight group for light coloured floats
    { 'GreyFloat', { background = P.grey } },
    { 'GreyFloatBorder', { foreground = P.grey } },
    -----------------------------------------------------------------------------//
    { 'CursorLine', { background = 'NONE' } },
    { 'CursorLineNr', { foreground = keyword_fg, background = 'NONE', bold = true } },
    { 'FoldColumn', { background = 'background' } },
    { 'Folded', { foreground = comment_fg, background = 'NONE', italic = true } },
    { 'TermCursor', { ctermfg = 'green', foreground = 'royalblue' } },
    -- {
    --   'IncSearch',
    --   {
    --     background = 'NONE',
    --     foreground = 'LightGreen',
    --     italic = true,
    --     bold = true,
    --     underline = true,
    --   },
    -- },
    -- Add undercurl to existing spellbad highlight
    { 'SpellBad', { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' } },
    { 'PmenuSbar', { background = P.grey } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    { 'DiffAdd', { background = '#26332c', foreground = 'NONE' } },
    { 'DiffDelete', { background = '#572E33', foreground = '#5c6370' } },
    { 'DiffChange', { background = '#273842', foreground = 'NONE' } },
    { 'DiffText', { background = '#314753', foreground = 'NONE' } },
    { 'diffAdded', { link = 'DiffAdd' } },
    { 'diffChanged', { link = 'DiffChange' } },
    { 'diffRemoved', { link = 'DiffDelete' } },
    { 'diffBDiffer', { link = 'WarningMsg' } },
    { 'diffCommon', { link = 'WarningMsg' } },
    { 'diffDiffer', { link = 'WarningMsg' } },
    { 'diffFile', { link = 'Directory' } },
    { 'diffIdentical', { link = 'WarningMsg' } },
    { 'diffIndexLine', { link = 'Number' } },
    { 'diffIsA', { link = 'WarningMsg' } },
    { 'diffNoEOL', { link = 'WarningMsg' } },
    { 'diffOnly', { link = 'WarningMsg' } },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    { 'Comment', { italic = true } },
    { 'Type', { italic = true, bold = true } },
    { 'Include', { italic = true, bold = false } },
    { 'Folded', { bold = true, italic = true } },
    { 'QuickFixLine', { background = search_bg } },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    { 'TSNamespace', { link = 'TypeBuiltin' } },
    { 'TSKeywordReturn', { italic = true, foreground = keyword_fg } },
    { 'TSParameter', { italic = true, bold = true, foreground = 'NONE' } },
    { 'TSError', { link = 'LspDiagnosticsUnderlineError' } },
    -- highlight FIXME comments
    { 'commentTSWarning', { foreground = 'Red', bold = true } },
    { 'commentTSDanger', { foreground = '#FBBF24', bold = true } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    -- avoid the urge to be "clever" and try and programmatically set these because
    -- 1. the name are slightly different (more than just the prefix) i.e. Warn -> Warning
    -- 2. Some plugins have not migrated so having both highlight groups is valuable
    { 'LspCodeLens', { link = 'NonText' } },
    { 'LspReferenceText', { underline = true, background = 'NONE' } },
    { 'LspReferenceRead', { underline = true, background = 'NONE' } },
    {
      'LspReferenceWrite',
      { underline = true, bold = true, background = 'NONE' },
    },
    { 'DiagnosticHint', { foreground = L.hint } },
    { 'DiagnosticError', { foreground = L.error } },
    { 'DiagnosticWarning', { foreground = L.warn } },
    { 'DiagnosticInfo', { foreground = L.info } },
    { 'DiagnosticUnderlineError', { undercurl = true, sp = L.error, foreground = 'none' } },
    { 'DiagnosticUnderlineHint', { undercurl = true, sp = L.hint, foreground = 'none' } },
    { 'DiagnosticUnderlineWarn', { undercurl = true, sp = L.warn, foreground = 'none' } },
    { 'DiagnosticUnderlineInfo', { undercurl = true, sp = L.info, foreground = 'none' } },
    { 'DiagnosticSignHintLine', { background = hint_line } },
    { 'DiagnosticSignErrorLine', { background = error_line } },
    { 'DiagnosticSignWarnLine', { background = warn_line } },
    { 'DiagnosticSignInfoLine', { background = info_line } },
    { 'DiagnosticSignWarn', { link = 'DiagnosticWarn' } },
    { 'DiagnosticSignInfo', { link = 'DiagnosticInfo' } },
    { 'DiagnosticSignHint', { link = 'DiagnosticHint' } },
    { 'DiagnosticSignError', { link = 'DiagnosticError' } },
    { 'DiagnosticFloatingWarn', { link = 'DiagnosticWarn' } },
    { 'DiagnosticFloatingInfo', { link = 'DiagnosticInfo' } },
    { 'DiagnosticFloatingHint', { link = 'DiagnosticHint' } },
    { 'DiagnosticFloatingError', { link = 'DiagnosticError' } },
    -- Exp
    { 'Todo', { foreground = 'red', bold = true } },
    {
      'Substitute',
      { foreground = comment_fg, background = 'NONE', strikethrough = true, bold = true },
    },
    { 'LspDiagnosticsFloatingWarning', { background = 'NONE' } },
    { 'LspDiagnosticsFloatingError', { background = 'NONE' } },
    { 'LspDiagnosticsFloatingHint', { background = 'NONE' } },
    { 'LspDiagnosticsFloatingInformation', { background = 'NONE' } },
    { 'LineNr', { background = 'NONE' } },
    { 'SignColumn', { background = 'NONE' } },
  }
end

local sidebar_highlight = function()
  local split_color = u.get_hl('VertSplit', 'fg')
  local st_color = u.alter_color(u.get_hl('Normal', 'bg'), -16)
  u.overwrite {
    { 'PanelBackground', { background = bg_color } },
    { 'PanelHeading', { background = bg_color, bold = true } },
    { 'PanelVertSplit', { foreground = split_color, background = bg_color } },
    { 'PanelStNC', { background = st_color, cterm = { italic = true } } },
    { 'PanelSt', { background = st_color } },
  }
end

local statusline = function()
  local indicator_color = P.bright_blue
  local warning_fg = L.warn

  local error_color = L.error
  local info_color = L.info
  local normal_fg = u.get_hl('Normal', 'fg')
  local pmenu_bg = u.get_hl('Pmenu', 'bg')
  local string_fg = u.get_hl('String', 'fg')
  local number_fg = u.get_hl('Number', 'fg')
  local identifier_fg = u.get_hl('Identifier', 'fg')

  u.overwrite {
    { 'StMetadata', { background = bg_color, inherit = 'Comment' } },
    {
      'StMetadataPrefix',
      { background = bg_color, inherit = 'Comment', italic = false, bold = false },
    },
    { 'StIndicator', { background = bg_color, foreground = indicator_color } },
    { 'StModified', { foreground = string_fg, background = bg_color } },
    { 'StGit', { foreground = P.white, background = P.dark_violet } },
    { 'StGreen', { foreground = string_fg, background = bg_color } },
    { 'StNumber', { foreground = number_fg, background = bg_color } },
    { 'StCount', { foreground = 'bg', background = indicator_color, bold = true } },
    { 'StPrefix', { background = pmenu_bg, foreground = normal_fg } },
    { 'StDirectory', { background = bg_color, foreground = 'Gray', italic = true } },
    { 'StParentDirectory', { background = bg_color, foreground = string_fg, bold = true } },
    { 'StIdentifier', { foreground = identifier_fg, background = bg_color } },
    { 'StTitle', { background = bg_color, foreground = 'LightGray', bold = true } },
    { 'StComment', { background = bg_color, inherit = 'Comment' } },
    { 'StInactive', { foreground = bg_color, background = P.comment_grey } },
    { 'StatusLine', { background = bg_color } },
    { 'StatusLineNC', { background = bg_color, italic = false, bold = false } },
    { 'StInfo', { foreground = info_color, background = bg_color, bold = true } },
    { 'StWarning', { foreground = warning_fg, background = bg_color } },
    { 'StError', { foreground = error_color, background = bg_color } },
    {
      'StFilename',
      { background = bg_color, foreground = 'LightGray', bold = true },
    },
    {
      'StFilenameInactive',
      { foreground = P.comment_grey, background = bg_color, bold = true, italic = true },
    },
    { 'StModeNormal', { background = P.cyan, foreground = 'Background', bold = true } },
    { 'StModeInsert', { background = P.magenta, foreground = 'Background', bold = true } },
    { 'StModeVisual', { background = P.yellow, foreground = 'Background', bold = true } },
    { 'StModeReplace', { background = P.green, foreground = 'Background', bold = true } },
    { 'StModeCommand', { background = P.orange, foreground = 'Background', bold = true } },
    { 'BarStModeNormal', { foreground = P.cyan, background = bg_color } },
    { 'BarStModeInsert', { foreground = P.magenta, background = bg_color } },
    { 'BarStModeVisual', { foreground = P.yellow, background = bg_color } },
    { 'BarStModeReplace', { foreground = P.green, background = bg_color } },
    { 'BarStModeCommand', { foreground = P.orange, background = bg_color } },
  }
end

local cheatsheet = function()
  u.overwrite {
    { 'CheatsheetBorder', { foreground = P.grey, background = bg_color } },
    { 'CheatsheetSectionContent', { background = bg_color } },
    { 'CheatsheetHeading', { foreground = P.light_red, bold = true } },
    { 'CheatsheetTitle1', { background = P.green, foreground = bg_color } },
    { 'CheatsheetTitle2', { background = P.magenta, foreground = bg_color } },
    { 'CheatsheetTitle3', { background = P.dark_orange, foreground = bg_color } },
    { 'CheatsheetTitle4', { background = P.light_red, foreground = bg_color } },
    { 'CheatsheetTitle5', { background = P.bright_blue, foreground = bg_color } },
    { 'CheatsheetTitle6', { background = P.bright_yellow, foreground = bg_color } },
  }
end

M.apply = function()
  general_heightlight()
  sidebar_highlight()
  statusline()
  cheatsheet()
end

return M
