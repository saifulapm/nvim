local g = vim.g
local action = require('nvim-tree.config').nvim_tree_callback
local u = require 'utils.color'
u.overwrite {
  { 'NvimTreeIndentMarker', { link = 'Comment' } },
  { 'NvimTreeNormal', { link = 'PanelBackground' } },
  { 'NvimTreeNormalNC', { link = 'PanelBackground' } },
  { 'NvimTreeSignColumn', { link = 'PanelBackground' } },
  { 'NvimTreeEndOfBuffer', { link = 'PanelBackground' } },
  { 'NvimTreeVertSplit', { link = 'PanelVertSplit' } },
  { 'NvimTreeStatusLine', { link = 'PanelSt' } },
  { 'NvimTreeStatusLineNC', { link = 'PanelStNC' } },
  { 'NvimTreeRootFolder', { bold = true, italic = true, foreground = 'LightMagenta' } },
}

g.nvim_tree_special_files = {}
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_indent_markers = 0
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_root_folder_modifier = ':t'
g.nvim_tree_group_empty = 1
g.nvim_tree_git_hl = 1

g.nvim_tree_window_picker_exclude = {
  filetype = { 'notify', 'packer', 'qf' },
  buftype = { 'terminal' },
}

g.nvim_tree_show_icons = {
  folders = 1,
  files = 1,
  git = 1,
}

g.nvim_tree_icons = {
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
}

require('nvim-tree').setup {
  view = {
    width = '20%',
    side = 'right',
    auto_resize = true,
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
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  open_on_tab = false,
  ignore_ft_on_setup = { 'dashboard' },
  auto_close = false,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store', 'fugitive:', '.git', '_compiled.lua', '.php-cs-fixer.dist.php' },
  },
}
