-- NOTE: This is default config, so dont change anything here. (check chadrc.lua instead)

local M = {}
M.ui, M.options, M.plugin_status, M.mappings, M.custom = {}, {}, {}, {}, {}

-- non plugin ui configs, available without any plugins
M.ui = {
  italic_comments = true,

  -- theme to be used, to see all available themes, open the theme switcher by <leader> + th
  theme = "onenord",

  -- theme toggler, toggle between two themes, see theme_toggleer mappings
  theme_toggler = {
    enabled = true,
    fav_themes = {
      'onedark',
      'everforest',
      'one-light',
    },
  },

  -- Enable this only if your terminal has the colorscheme set which nvchad uses
  -- For Ex : if you have onedark set in nvchad , set onedark's bg color on your terminal
  transparency = false,
}

-- plugin related ui options
M.ui.plugin = {
  -- statusline related options
  statusline = {
    -- these are filetypes, not pattern matched
    -- if a filetype is present in shown, it will always show the statusline, irrespective of filetypes in hidden
    hidden = {
      'help',
      'dashboard',
      'NvimTree',
      'terminal',
    },
    shown = {},
    -- default, round , slant , block , arrow
    style = 'arrow',
  },
}

-- non plugin normal, available without any plugins
M.options = {
  copy_cut = true, -- copy cut text ( x key ), visual and normal mode
  copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
  insert_nav = true, -- navigation in insertmode
}

-- these are plugin related options
M.options.plugin = {
  autosave = true, -- autosave on changed text or insert mode leave
  -- timeout to be used for using escape with a key combination, see mappings.plugin.better_escape
  esc_insertmode_timeout = 300,
}

-- mappings -- don't use a single keymap twice --
-- non plugin mappings
M.mappings = {
  -- close current focused buffer
  close_buffer = '<leader>x',
  copy_whole_file = '<C-a>', -- copy all contents of the current buffer

  -- Reload Theme (If any change you made in current colors)
  reload_theme = '<Leader>tr',

  -- navigation in insert mode, only if enabled in options
  insert_nav = {
    backward = '<C-h>',
    end_of_line = '<C-e>',
    forward = '<C-l>',
    next_line = '<C-k>',
    prev_line = '<C-j>',
    top_of_line = '<C-a>',
  },

  new_buffer = '<S-t>', -- open a new buffer
  new_tab = '<C-t>b', -- open a new vim tab
  save_file = '<C-s>', -- save file using :w
  theme_toggler = '<leader>tt', -- for theme toggler, see in ui.theme_toggler

  -- terminal related mappings
  terminal = {
    -- multiple mappings can be given for esc_termmode and esc_hide_termmode
    -- get out of terminal mode
    esc_termmode = { 'jk' }, -- multiple mappings allowed
    -- get out of terminal mode and hide it
    -- it does not close it, see pick_term mapping to see hidden terminals
    esc_hide_termmode = { 'JK' }, -- multiple mappings allowed
    -- show hidden terminal buffers in a telescope picker
    pick_term = '<leader>W',
    -- below three are for spawning terminals
    new_horizontal = '<leader>h',
    new_vertical = '<leader>v',
    new_window = '<leader>w',
  },
}

-- all plugins related mappings
-- to get short info about a plugin, see the respective string in plugin_status, if not present, then info here
M.mappings.plugin = {
  bufferline = {
    next_buffer = '<Leader><TAB>', -- next buffer
    prev_buffer = '<S-Tab>', -- previous buffer
    --better window movement
    moveLeft = '<C-h>',
    moveRight = '<C-l>',
    moveUp = '<C-k>',
    moveDown = '<C-j>',
  },
  cheatsheet = {
    default_keys = '<leader>dk',
    user_keys = '<leader>uk',
  },
  todo_comments = {
    toggle = '<leader>lt',
  },
  -- note: this is an edditional mapping to escape, escape key will still work
  better_escape = {
    esc_insertmode = { 'jk' }, -- multiple mappings allowed
  },
  nvimtree = {
    -- file tree
    toggle = '<C-n>',
    focus = '<leader>e',
  },
  telescope = {
    buffers = '<leader>fo',
    buffer_fuzzy = '<leader>fb',
    find_files = '<leader>ff',
    find_hiddenfiles = '<leader>fa',
    git_commits = '<leader>fgc',
    git_branches = '<leader>fgt',
    man_pages = '<leader>fm',
    help_tags = '<leader>f?',
    nvim_config = '<Leader>fn',
    live_grep = '<leader>fs',
    grep_under_cursor_word = '<leader>fw',
    history = '<leader>fh',
    themes = '<leader>th',
    builtins = '<leader>fa',
    dotfiles = '<leader>fd',
    installed_plugins = '<Leader>fp',
    orgfiles = '<Leader>fO',
    module_reloader = '<leader>fR',
    resume_last_picker = '<Leader>fr',
    tmux_sessions = '<leader>fts',
    tmux_windows = '<leader>ftw',
    lsp_workspace_diagnostics = '<leader>cd',
    lsp_document_symbols = '<Leader>cs',
    lsp_dynamic_workspace_symbols = '<leader>cw',
  },
  truezen = { -- distraction free modes mapping, hide statusline, tabline, line numbers
    ataraxis_mode = '<leader>zz', -- center
    focus_mode = '<leader>zf',
    minimalistic_mode = '<leader>zm', -- as it is
  },
  session = {
    session_save = '<leader>s',
    session_load = '<leader>l',
  },
}

-- user custom mappings
-- e.g: name = { "mode" , "keys" , "cmd" , "options"}
-- name: can be empty or something unique with repect to other custom mappings
--    { mode, key, cmd } or name = { mode, key, cmd }
-- mode: usage: mode or { mode1, mode2 }, multiple modes allowed, available modes => :h map-modes,
-- keys: multiple keys allowed, same synxtax as modes
-- cmd:  for vim commands, must use ':' at start and add <CR> at the end if want to execute
-- options: see :h nvim_set_keymap() opts section
M.custom.mappings = {
  -- clear_all = {
  --    "n",
  --    "<leader>cc",
  --    "gg0vG$d",
  -- },
}

M.plugins = {
  lspconfig = {
    -- servers = {"html", "cssls"}
    servers = {},
  },
}
return M
