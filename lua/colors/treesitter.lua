local M = {}
local colors = G.style.colors
local utils = require 'utils.colors'

M.highlights = {
  TSStrike = {
    fg = utils.Darken(colors.violet, 0.2),
    strikethrough = true,
  },
  TSException = { link = 'Exception' },
  TSAnnotation = { link = 'PreProc' },
  TSAttribute = { link = 'Attribute' },
  TSConditional = { link = 'Conditional' },
  TSComment = { link = 'Comment' },
  TSConstructor = { link = 'Structure' },
  TSConstant = { link = 'Constant' },
  TSConstBuiltin = { link = 'Constant' },
  TSConstMacro = { link = 'Macro' },
  TSError = { link = 'Error' },
  TSField = { link = 'Field' },
  TSFloat = { link = 'Float' },
  TSFunction = { link = 'Function' },
  TSFuncBuiltin = { link = 'FunctionBuiltin' },
  TSFuncMacro = { link = 'Macro' },
  TSInclude = { link = 'Include' },
  TSKeyword = { link = 'Keyword' },
  TSKeywordFunction = { link = 'KeywordFunction' },
  TSLabel = { link = 'Label' },
  TSMethod = { link = 'Method' },
  TSNamespace = { link = 'Directory' },
  TSNumber = { link = 'Number' },
  TSOperator = { link = 'Operator' },
  TSParameter = { link = 'Argument' },
  TSParameterReference = { link = 'Argument' },
  TSProperty = { link = 'Property' },
  TSPunctDelimiter = { link = 'Delimiter' },
  TSPunctBracket = { link = 'Delimiter' },
  TSPunctSpecial = { link = 'Delimiter' },
  TSRepeat = { link = 'Repeat' },
  TSString = { link = 'String' },
  TSStringRegex = { link = 'StringDelimiter' },
  TSStringEscape = { link = 'StringDelimiter' },
  TSTag = { link = 'Tag' },
  TSTagDelimiter = { link = 'Delimiter' },
  TSStrong = { link = 'Bold' },
  TSURI = { link = 'URL' },
  TSWarning = { link = 'WarningMsg' },
  TSDanger = { link = 'ErrorMsg' },
  TSType = { link = 'Type' },
  TSTypeBuiltin = { link = 'TypeBuiltin' },
  TSVariable = { link = 'None' },
  TSVariableBuiltin = { link = 'VariableBuiltin' },
}

M.apply = function()
  for hl, col in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return M
