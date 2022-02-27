local M = {}

M.mappings = {
  misc = {
    cheatsheet = '<leader>ch',
    close_buffer = '<leader>x',
    clear_all_buffers = '<leader>da',
    scratch_buffer = '<leader>B',
    delete_other_buffers = '<Leader>on',
    toggle_last_file = '<Leader><Leader>',
    copy_whole_file = '<C-a>', -- copy all contents of current buffer
    line_number_toggle = '<leader>n', -- toggle line number
    relative_line_number_toggle = '<leader>rn',
    go_to_matching = '<Tab>',
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

  -- navigation in insert mode, only if enabled in options

  insert_nav = {
    backward = '<C-h>',
    end_of_line = '<C-e>',
    forward = '<C-l>',
    next_line = '<C-j>',
    prev_line = '<C-k>',
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
    replace_selection = '<Leader>r',
    replace_selection_wc = '<Leader>R',
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
    -- multiple mappings can be given for esc_termmode, esc_hide_termmode

    -- get out of terminal mode
    esc_termmode = { 'jk' },

    -- get out of terminal mode and hide it
    esc_hide_termmode = { 'JK' },
    -- show & recover hidden terminal buffers in a telescope picker
    pick_term = '<leader>W',

    -- spawn terminals
    new_horizontal = '<leader>h',
    new_vertical = '<leader>v',
    new_window = '<leader>w',
  },
}

M.mappings.plugins = {
  bufferline = {
    next_buffer = '<Leader><TAB>',
    prev_buffer = '<S-Tab>',
    move_buffer_next = ']b',
    move_buffer_prev = '[b',
  },
  comment = {
    toggle = '<leader>/',
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
    save_session = '<Leader>ss',
    restore_session = '<Leader>sl',
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
    buffers = '<leader>fb',
    find_files = '<leader>ff',
    find_hiddenfiles = '<leader>fa',
    git_commits = '<leader>cm',
    git_status = '<leader>gt',
    help_tags = '<leader>fh',
    live_grep = '<leader>fw',
    oldfiles = '<leader>fo',
  },
}

return M