require('indent_blankline').setup {
  char = '│', -- ┆ ┊ 
  show_foldtext = false,
  context_char = '┃',
  char_priority = 12,
  show_current_context = false,
  show_current_context_start = false,
  show_current_context_start_on_current_line = false,
  show_first_indent_level = false,
  filetype_exclude = {
    'dbout',
    'neo-tree-popup',
    'dap-repl',
    'startify',
    'dashboard',
    'log',
    'fugitive',
    'gitcommit',
    'packer',
    'vimwiki',
    'markdown',
    'txt',
    'vista',
    'help',
    'NvimTree',
    'git',
    'TelescopePrompt',
    'undotree',
    'flutterToolsOutline',
    'norg',
    'org',
    'orgagenda',
    '', -- for all buffers without a file type
  },
  buftype_exclude = { 'terminal', 'nofile' },
}
