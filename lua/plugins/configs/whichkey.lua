local wk = require 'which-key'
wk.setup {
  plugins = {
    spelling = {
      enabled = true,
    },
  },
  window = {
    border = G.style.border.line,
  },
  layout = {
    align = 'center',
  },
}
