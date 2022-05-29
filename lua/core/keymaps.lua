local M = {}

M.mappings = {
  misc = {
    cheatsheet = '<leader>ch',
    close_buffer = '<leader>x',
    clear_all_buffers = '<leader>da',
    scratch_buffer = '<leader>B',
    delete_other_buffers = '<Leader>on',
    toggle_last_file = '<Leader><Leader>',
    line_number_toggle = '<leader>n', -- toggle line number
    relative_line_number_toggle = '<leader>rn',
    -- go_to_matching = '<C-Tab>',
    new_buffer = '<S-t>',
    new_tab = '<C-t>b',
    save_file = '<C-s>', -- save file using :w
    no_highlight = '<Esc>',
    refocus_fold = '<localleader>z',
    open_all_folds = 'zO',
    recent_40_messages = 'g>',
    blank_line_above = '[<space>',
    blank_line_below = ']<space>',
    line_move_up = '<A-k>',
    line_move_down = '<A-j>',
  },

  insert_nav = {
    -- backward = '<C-h>',
    end_of_line = '<C-e>',
    -- forward = '<C-l>',
    -- next_line = '<C-j>',
    -- prev_line = '<C-k>',
    beginning_of_line = '<C-a>',
    delete_by_word = '<C-w>',
    delete_by_line = '<C-u>',
    delete = '<C-d>',
    curly_brackets = '[c',
    save = '<C-s>',
  },

  command_nav = {
    backward = '<C-h>',
    end_of_line = '<C-e>',
    forward = '<C-l>',
    beginning_of_line = '<C-a>',
    delete = '<C-d>',
    expand_directory = '<C-t>',
  },

  visual_mode_mappings = {
    macros_on_selected_area = '@',
    search_on_selected_area = '//',
    line_move_up = '<A-k>',
    line_move_down = '<A-j>',
    replace_selection = '<leader>r',
    replace_selection_wc = '<leader>R',
  },

  -- better window movement
  window_nav = {
    moveLeft = '<C-h>',
    moveRight = '<C-l>',
    moveUp = '<C-k>',
    moveDown = '<C-j>',
  },

  -- terminal related mappings
  terminal = {
    toggle_terminal = '<C-\\>',
  },

  plugins = {
    bufferline = {
      next_buffer = '<leader><TAB>',
      prev_buffer = '<S-Tab>',
      move_buffer_next = ']b',
      move_buffer_prev = '[b',
      pick_buffer = 'gb',
      pick_close = 'gB',
    },
    comment = {
      toggle = '<leader>/',
    },

    dial = {
      increase = '<C-a>',
      decrease = '<C-x>',
    },

    toggle_character = {
      toggle_comma = '<localleader>,',
      toggle_semicolon = '<localleader>;',
    },

    -- map to <ESC> with no lag
    better_escape = { -- <ESC> will still work
      esc_insertmode = { 'jk' }, -- multiple mappings allowed
    },

    session = {
      save_session = '<leader>ss',
      restore_session = '<leader>sl',
    },

    lspconfig = {
      declaration = 'gD',
      definition = 'gd',
      hover = 'K',
      implementation = 'gi',
      signature_help = 'gk',
      add_workspace_folder = '<leader>wa',
      remove_workspace_folder = '<leader>wr',
      list_workspace_folders = '<leader>wl',
      type_definition = '<leader>D',
      rename = '<leader>ra',
      code_action = '<leader>ca',
      references = 'gr',
      float_diagnostics = 'ge',
      goto_prev = '[d',
      goto_next = ']d',
      set_loclist = '<leader>q',
      formatting = '<leader>fm',
    },

    nvimtree = {
      toggle = '<C-n>',
      focus = '<leader>e',
    },

    telescope = {
      project_files = '<C-p>',
      builtins = '<leader>fa',
      current_buffer_fuzzy_find = '<leader>fb',
      dotfiles = '<leader>fd',
      dash_app_search = '<leader>fD',
      find_files = '<leader>ff',
      git_commits = '<leader>fgc',
      git_branches = '<leader>fgb',
      pull_requests = '<leader>fgp',
      man_pages = '<leader>fm',
      history = '<leader>fh',
      nvim_config = '<leader>fc',
      buffers = '<leader>fo',
      installed_plugins = '<leader>fp',
      orgfiles = '<leader>fO',
      norgfiles = '<leader>fN',
      module_reloader = '<leader>fR',
      resume_last_picker = '<leader>fr',
      grep_string = '<leader>fs',
      tmux_sessions = '<leader>fts',
      tmux_windows = '<leader>ftw',
      -- help_tags = '<leader>f?',
      lsp_workspace_diagnostics = '<leader>cd',
      lsp_document_symbols = '<leader>cs',
      lsp_dynamic_workspace_symbols = '<leader>cw',
    },

    harpoon = {
      add = '<localleader>a',
      toggle = '<localleader>f',
      next = '<localleader>n',
      prev = '<localleader>b',
    },
  },
}

return M
