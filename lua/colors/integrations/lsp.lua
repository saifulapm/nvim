local colors = require('colors').load()

return {
  ErrorMsgUnderline = { foreground = colors.red, underline = true },
  WarningMsgUnderline = { foreground = colors.yellow, underline = true },
  MoreMsgUnderline = { foreground = colors.blue, underline = true },
  MsgUnderline = { foreground = colors.green, underline = true },
  LspDiagnosticsFloatingError = { link = 'ErrorMsg' },
  LspDiagnosticsFloatingWarning = { link = 'WarningMsg' },
  LspDiagnosticsFloatingInformation = { link = 'MoreMsg' },
  LspDiagnosticsFloatingHint = { link = 'Msg' },
  LspDiagnosticsDefaultError = { link = 'ErrorMsg' },
  LspDiagnosticsDefaultWarning = { link = 'WarningMsg' },
  LspDiagnosticsDefaultInformation = { link = 'MoreMsg' },
  LspDiagnosticsDefaultHint = { link = 'Msg' },
  LspDiagnosticsVirtualTextError = { link = 'ErrorMsg' },
  LspDiagnosticsVirtualTextWarning = { link = 'WarningMsg' },
  LspDiagnosticsVirtualTextInformation = { link = 'MoreMsg' },
  LspDiagnosticsVirtualTextHint = { link = 'Msg' },
  LspDiagnosticsUnderlineError = { link = 'ErrorMsgUnderline' },
  LspDiagnosticsUnderlineWarning = { link = 'WarningMsgUnderline' },
  LspDiagnosticsUnderlineInformation = { link = 'MoreMsgUnderline' },
  LspDiagnosticsUnderlineHint = { link = 'MsgUnderline' },
  LspDiagnosticsSignError = { link = 'ErrorMsg' },
  LspDiagnosticsSignWarning = { link = 'WarningMsg' },
  LspDiagnosticsSignInformation = { link = 'MoreMsg' },
  LspDiagnosticsSignHint = { link = 'Msg' },
  DiagnosticFloatingError = { link = 'ErrorMsg' },
  DiagnosticFloatingWarn = { link = 'WarningMsg' },
  DiagnosticFloatingInfo = { link = 'MoreMsg' },
  DiagnosticFloatingHint = { link = 'Msg' },
  DiagnosticDefaultError = { link = 'ErrorMsg' },
  DiagnosticDefaultWarn = { link = 'WarningMsg' },
  DiagnosticDefaultInfo = { link = 'MoreMsg' },
  DiagnosticDefaultHint = { link = 'Msg' },
  DiagnosticUnderlineError = { link = 'ErrorMsgUnderline' },
  DiagnosticUnderlineWarn = { link = 'WarningMsgUnderline' },
  DiagnosticUnderlineInfo = { link = 'MoreMsgUnderline' },
  DiagnosticUnderlineHint = { link = 'MsgUnderline' },
  DiagnosticSignError = { link = 'ErrorMsg' },
  DiagnosticSignWarning = { link = 'WarningMsg' },
  DiagnosticSignInformation = { link = 'MoreMsg' },
  DiagnosticSignHint = { link = 'Msg' },
  DiagnosticVirtualTextError = { link = 'ErrorMsg' },
  DiagnosticVirtualTextWarn = { link = 'WarningMsg' },
  DiagnosticVirtualTextInfo = { link = 'MoreMsg' },
  DiagnosticVirtualTextHint = { link = 'TextMuted' },
  LspReferenceText = { link = 'LspHighlight' },
  LspReferenceRead = { link = 'LspHighlight' },
  LspReferenceWrite = { link = 'LspHighlight' },
  TermCursor = { link = 'Cursor' },
  healthError = { link = 'ErrorMsg' },
  healthSuccess = { link = 'Msg' },
  healthWarning = { link = 'WarningMsg' },
}
