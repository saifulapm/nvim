local parsers = require 'nvim-treesitter.parsers'

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'lua',
    'go',
    'dart',
    'rust',
    'typescript',
    'javascript',
    'comment',
    'markdown',
    'markdown_inline',
    'php',
    'norg',
    'json',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { 'yaml' },
  },
}
