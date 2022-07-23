local action = require('nvim-tree.config').nvim_tree_callback
require('colors').load_highlight 'nvimtree'

require('nvim-tree').setup {
  view = {
    width = '20%',
    side = 'right',
    hide_root_folder = true,
    mappings = {
      custom_only = false,
      list = {
        { key = 'cd', cb = action 'cd' },
        { key = 'v', cb = action 'vsplit' },
        { key = 's', cb = action 'split' },
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    highlight_opened_files = 'none',
    root_folder_modifier = ':~',
    special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
    indent_markers = {
      enable = false,
      icons = {
        corner = '└ ',
        edge = '│ ',
        none = '  ',
      },
    },
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        git = {
          deleted = '',
          ignored = '◌',
          renamed = '➜',
          staged = '✓',
          unmerged = '',
          unstaged = '✗',
          untracked = '★',
        },
        folder = {
          default = '',
          empty = '',
          empty_open = '',
          open = '',
          symlink = '',
          symlink_open = '',
        },
      },
    },
  },
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  open_on_tab = false,
  ignore_ft_on_setup = { 'dashboard' },
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store', 'fugitive:', '.git/', '_compiled.lua', '.php-cs-fixer.dist.php' },
  },
}
