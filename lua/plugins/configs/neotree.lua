local icons = G.style.icons
local highlights = require 'core.highlights'

highlights.plugin('NeoTree', {
  NeoTreeIndentMarker = { link = 'Comment' },
  NeoTreeNormal = { link = 'PanelBackground' },
  NeoTreeNormalNC = { link = 'PanelBackground' },
  NeoTreeRootName = { bold = true, italic = true, foreground = 'LightMagenta' },
  NeoTreeCursorLine = { link = 'Visual' },
  NeoTreeStatusLine = { link = 'PanelSt' },
  NeoTreeTabBackground = { link = 'PanelDarkBackground' },
  NeoTreeTab = { bg = { from = 'PanelDarkBackground' }, fg = { from = 'Comment' } },
  NeoTreeSeparator = { link = 'PanelDarkBackground' },
  NeoTreeActiveTab = { bg = { from = 'PanelBackground' }, fg = 'fg', bold = true },
})

vim.g.neo_tree_remove_legacy_commands = 1

vim.keymap.set('n', '<c-n>', '<Cmd>Neotree toggle reveal<CR>', { noremap = true })

require('neo-tree').setup {
  enable_git_status = true,
  git_status_async = true,
  event_handlers = {
    {
      event = 'neo_tree_buffer_enter',
      handler = function()
        highlights.set_hl('Cursor', { blend = 100 })
      end,
    },
    {
      event = 'neo_tree_buffer_leave',
      handler = function()
        highlights.set_hl('Cursor', { blend = 0 })
      end,
    },
  },
  filesystem = {
    hijack_netrw_behavior = 'open_current',
    use_libuv_file_watcher = true,
    group_empty_dirs = true,
    follow_current_file = false,
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
      never_show = {
        '.DS_Store',
      },
    },
  },
  default_component_configs = {
    icon = {
      folder_empty = '',
    },
    git_status = {
      symbols = {
        added = icons.git.add,
        deleted = icons.git.remove,
        modified = icons.git.mod,
        renamed = icons.git.rename,
        untracked = '',
        ignored = '',
        unstaged = '',
        staged = '',
        conflict = '',
      },
    },
  },
  window = {
    position = 'right',
    mappings = {
      o = 'toggle_node',
      ['<CR>'] = 'open_with_window_picker',
      ['<c-s>'] = 'split_with_window_picker',
      ['<c-v>'] = 'vsplit_with_window_picker',
    },
  },
}
