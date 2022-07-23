local colors = require('colors').load()

return {
  IndentBlanklineChar = {
    foreground = colors.base4,
    cterm = 'nocombine',
    gui = 'nocombine',
  },
  IndentBlanklineContextChar = {
    foreground = colors.blue,
    cterm = 'nocombine',
    nocombine = true,
  },
  IndentBlanklineSpaceChar = {
    foreground = colors.base4,
    cterm = 'nocombine',
    nocombine = true,
  },
  IndentBlanklineSpaceCharBlankline = {
    foreground = colors.base4,
    cterm = 'nocombine',
    nocombine = true,
  },
}
