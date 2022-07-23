local M = {}
local colors = G.style.colors
local utils = require 'utils.colors'
local fg_highlight = utils.Lighten(colors.fg, 0.2)

M.highlights = {
  Normal = { foreground = colors.fg, background = colors.bg },
  NormalPopup = {
    foreground = fg_highlight,
    background = colors.bg_alt,
  },
  NormalPopover = {
    foreground = fg_highlight,
    background = colors.bg_alt,
  },
  NormalPopupPrompt = {
    foreground = colors.base7,
    background = utils.Darken(colors.bg_alt, 0.3),
    bold = true,
  },
  NormalPopupSubtle = {
    foreground = colors.base6,
    background = colors.bg_alt,
  },
  EndOfBuffer = {
    foreground = colors.bg,
    background = colors.bg,
  },

  Visual = { background = colors.dark_blue },
  VisualBold = { background = colors.dark_blue, bold = true },

  LineNr = {
    foreground = colors.grey,
    background = colors.bg,
  },
  Cursor = { background = colors.blue },
  CursorLine = { background = colors.bg_highlight },
  CursorLineNr = { foreground = colors.fg, background = colors.bg_highlight },
  CursorColumn = { background = colors.bg_highlight },

  Folded = { foreground = colors.base5, background = colors.bg_highlight },
  FoldColumn = { foreground = colors.fg_alt, background = colors.bg },
  SignColumn = { background = colors.bg },
  ColorColumn = { background = colors.bg_highlight },

  IndentGuide = { foreground = colors.grey },
  IndentGuideEven = { foreground = colors.grey },
  IndentGuideOdd = { foreground = colors.grey },

  TermCursor = { foreground = colors.fg, reverse = true },
  TermCursorNC = { foreground = colors.fg_alt, reverse = true },
  TermNormal = { foreground = colors.fg, background = colors.bg },
  TermNormalNC = { foreground = colors.fg, background = colors.bg },

  WildMenu = { foreground = colors.fg, background = colors.dark_blue },
  Separator = { foreground = colors.fg_alt },
  VertSplit = { foreground = colors.grey, background = colors.bg },

  TabLine = {
    foreground = colors.base7,
    background = colors.bg_alt,
    bold = true,
  },
  TabLineSel = { foreground = colors.blue, background = colors.bg, bold = true },
  TabLineFill = { background = colors.base1, bold = true },

  StatusLine = { foreground = colors.base8, background = colors.base3 },
  StatusLineNC = { foreground = colors.base6, background = colors.bg_alt },
  StatusLinePart = { foreground = colors.base6, background = colors.bg_alt, bold = true },
  StatusLinePartNC = { foreground = colors.base6, background = colors.bg_alt, bold = true },

  Pmenu = { foreground = colors.fg, background = colors.bg_highlight },
  PmenuSel = { foreground = colors.base0, background = colors.blue },
  PmenuSelBold = { foreground = colors.base0, background = colors.blue, bold = true },
  PmenuSbar = { background = colors.bg_alt },
  PmenuThumb = { background = colors.fg },

  -- Search, Highlight. Conceal, Messages
  Search = { foreground = colors.fg, background = colors.dark_blue, bold = true },
  Substitute = { foreground = colors.red, strikethrough = true, bold = true },
  IncSearch = { foreground = colors.fg, background = colors.dark_blue, bold = true },
  IncSearchCursor = { reverse = true },

  Conceal = { foreground = colors.grey, bold = false, italic = false },
  SpecialKey = { foreground = colors.violet, bold = true },
  NonText = { foreground = colors.fg_alt, bold = true },
  MatchParen = { foreground = colors.red, bold = true },
  Whitespace = { foreground = colors.grey },

  Highlight = { background = colors.bg_highlighted },
  HighlightSubtle = { background = colors.bg_highlighted },
  LspHighlight = { background = colors.bg_highlight, bold = true },

  Question = { foreground = colors.green, bold = true },

  File = { foreground = colors.fg },
  Directory = { foreground = colors.violet, bold = true },
  Title = { foreground = colors.violet, bold = true },

  Bold = { bold = true },
  Emphasis = { foreground = colors.green, bold = true },

  -- Text levels
  TextNormal = { foreground = colors.fg },
  TextInfo = { foreground = colors.blue },
  TextSuccess = { foreground = colors.green },
  TextWarning = { foreground = colors.yellow },
  TextDebug = { foreground = colors.yellow },
  TextError = { foreground = colors.red },
  TextSpecial = { foreground = colors.violet },
  TextMuted = { foreground = colors.base7 },
  TextNormalBold = { foreground = colors.fg, bold = true },
  TextInfoBold = { foreground = colors.blue, bold = true },
  TextSuccessBold = { foreground = colors.green, bold = true },
  TextWarningBold = { foreground = colors.yellow, bold = true },
  TextDebugBold = { foreground = colors.yellow, bold = true },
  TextErrorBold = { foreground = colors.red, bold = true },
  TextSpecialBold = { foreground = colors.violet, bold = true },
  TextMutedBold = { foreground = colors.base7, bold = true },

  Msg = { link = 'TextSuccess' },
  MoreMsg = { link = 'TextInfo' },
  WarningMsg = { link = 'TextWarning' },
  Error = { link = 'TextError' },
  ErrorMsg = { link = 'TextError' },
  ModeMsg = { link = 'TextSpecial' },
  Todo = { link = 'TextWarningBold' },

  -- Harpoon
  HarpoonBorder = { foreground = colors.grey },
  -- Marks
  MarkSignHL = { foreground = colors.red },

  -- Panel
  PanelDarkBackground = { background = colors.bg_alt },
  PanelDarkHeading = { background = colors.bg_alt, bold = true },
  PanelBackground = { background = colors.bg },
  PanelHeading = { background = colors.bg, bold = true },
  PanelVertSplit = { foreground = colors.grey, background = colors.bg },
  PanelWinSeparator = { foreground = colors.grey, background = colors.bg },
  PanelStNC = { background = colors.bg, foreground = colors.grey },
  PanelSt = { background = colors.bg_statusline },
}

M.apply = function()
  for hl, col in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

M.load_highlight = function(group) end

return M
