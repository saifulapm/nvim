require('colors').load_highlight 'blankline'
require('indent_blankline').setup {
  char = '┊', -- ┆ ┊  ┊
  show_foldtext = false,
  context_char = '▏',
  filetype_exclude = {
    'dashboard',
    'DogicPrompt',
    'log',
    'fugitive',
    'gitcommit',
    'packer',
    'markdown',
    'json',
    'txt',
    'vista',
    'help',
    'todoist',
    'NvimTree',
    'git',
    'TelescopePrompt',
    'undotree',
  },
  buftype_exclude = { 'terminal', 'nofile', 'prompt' },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}
