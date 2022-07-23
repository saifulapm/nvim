local M = {}
local colors = G.style.colors
local utils = require 'utils.colors'
local tag = utils.Mix(colors.blue, colors.cyan, 0.5)
local light_magenta = utils.Darken(colors.magenta, 0.36)

-- Standard syntax highlighting

M.highlights = {
  Tag = { foreground = tag, bold = true },
  Link = { foreground = colors.green, underline = true },
  URL = { foreground = colors.green, underline = true },
  Underlined = { foreground = tag, underline = true },

  Comment = {
    foreground = colors.fg_alt,
    italic = true,
  },
  CommentBold = { foreground = colors.fg_alt, bold = true },
  SpecialComment = { foreground = colors.base7, bold = true },

  Macro = { foreground = colors.violet },
  Define = { foreground = colors.violet, bold = true },
  Include = { foreground = colors.violet, bold = true },
  PreProc = { foreground = colors.violet, bold = true },
  PreCondit = { foreground = colors.violet, bold = true },

  Label = { foreground = colors.blue },
  Repeat = { foreground = colors.blue },
  Keyword = { foreground = colors.blue },
  Operator = { foreground = colors.blue },
  Delimiter = { foreground = colors.blue },
  Statement = { foreground = colors.blue },
  Exception = { foreground = colors.blue },
  Conditional = { foreground = colors.blue },

  Variable = { foreground = '#8B93E6' },
  VariableBuiltin = { foreground = '#8B93E6', bold = true },
  Constant = { foreground = colors.violet, bold = true },

  Number = { foreground = colors.orange },
  Float = { foreground = colors.orange },
  Boolean = { foreground = colors.orange, bold = true },
  Enum = { foreground = colors.orange },

  Character = { foreground = colors.violet, bold = true },
  SpecialChar = { foreground = colors.base8, bold = true },

  String = { foreground = colors.green },
  StringDelimiter = { foreground = colors.green },

  Special = { foreground = colors.violet },
  SpecialBold = { foreground = colors.violet, bold = true },

  Field = { foreground = colors.violet },
  Argument = { foreground = light_magenta },
  Attribute = { foreground = light_magenta },
  Property = { foreground = colors.magenta },
  Function = { foreground = colors.magenta },
  FunctionBuiltin = { foreground = light_magenta, bold = true },
  KeywordFunction = { foreground = colors.blue },
  Method = { foreground = colors.violet },

  Type = { foreground = colors.yellow },
  TypeBuiltin = { foreground = colors.yellow, bold = true },
  StorageClass = { foreground = colors.blue },
  Class = { foreground = colors.blue },
  Structure = { foreground = colors.blue },
  Typedef = { foreground = colors.blue },

  Regexp = { foreground = '#dd0093' },
  RegexpSpecial = { foreground = '#a40073' },
  RegexpDelimiter = { foreground = '#540063', bold = true },
  RegexpKey = { foreground = '#5f0041', bold = true },

  CommentURL = { link = 'URL' },
  CommentLabel = { link = 'CommentBold' },
  CommentSection = { link = 'CommentBold' },
  Noise = { link = 'Comment' },

  -- Markdown
  markdownCode = { background = colors.bg_highlight },
  markdownCodeBlock = { background = colors.bg_highlight },
  markdownH1 = { bold = true },
  markdownH2 = { bold = true },
  markdownLinkText = { underline = true },

  -- netrw
  netrwClassify = { foreground = colors.blue },
  netrwDir = { foreground = colors.blue },
  netrwExe = { foreground = colors.green },
  netrwMakefile = { foreground = colors.yellow },
}

M.apply = function()
  for hl, col in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return M
