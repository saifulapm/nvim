local icons = G.style.icons
vim.g.neo_tree_remove_legacy_commands = 1

vim.keymap.set('n', '<c-n>', '<Cmd>Neotree toggle reveal<CR>')

require('colors').load_highlight 'neotree'
require('neo-tree').setup {
  enable_git_status = true,
  git_status_async = true,
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
