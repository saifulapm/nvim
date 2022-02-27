local M = {}
local add_highlight = vim.api.nvim_buf_add_highlight

local format = function(str)
  return (str:gsub('_', ' '):gsub('^%l', string.upper))
end

local function display_cheatsheet(mappings)
  if vim.g.mappings_displayed then
    return
  end

  vim.g.mappings_displayed = true
  vim.cmd [[autocmd BufWinLeave * ++once lua vim.g.mappings_displayed = false]]

  local function spaces(amount)
    return string.rep(' ', amount)
  end

  local ns = vim.api.nvim_create_namespace 'mappings'

  local lines = {}

  local win, buf
  local heading_lines = {}
  local section_lines = {}
  local section_titles = {}
  local border_lines = {}

  local width = vim.o.columns
  local height = vim.o.lines

  local function parse_mapping(mapping)
    mapping = string.gsub(mapping, 'C%-', 'Ctrl+')
    mapping = string.gsub(mapping, 'c%-', 'Ctrl+')
    mapping = string.gsub(mapping, '%<leader%>', 'Leader+')
    mapping = string.gsub(mapping, '%<(.+)%>', '%1')
    return mapping
  end

  local spacing = 3
  local popup_width = math.floor(width * 0.4)

  if spacing < 2 then
    spacing = 0
  end

  local line_nr = 0

  for main_sec, section_contents in pairs(mappings) do
    -- table.insert(lines, " ")
    table.insert(
      lines,
      spaces(math.floor(width * 0.4 / 2) - math.floor(#main_sec / 2))
        .. main_sec
    )

    line_nr = line_nr + 1
    table.insert(section_titles, line_nr)

    for Title, values in pairs(section_contents) do
      if type(values) == 'table' then
        lines[#lines + 1] = ' '
        line_nr = line_nr + 1
        lines[#lines + 1] = spaces(spacing) .. format(Title) .. spaces(spacing)

        table.insert(heading_lines, line_nr)

        line_nr = line_nr + 1
        lines[#lines + 1] = ' '
        line_nr = line_nr + 1

        table.insert(
          lines,
          spaces(spacing)
            .. '┌'
            .. string.rep('─', popup_width - 8)
            .. '┐'
        )
        table.insert(border_lines, line_nr)

        line_nr = line_nr + 1

        for mapping, key in pairs(values) do
          if type(key) == 'string' then
            key = parse_mapping(key)
            table.insert(
              lines,
              spaces(spacing)
                .. '│ '
                .. format(mapping)
                .. string.rep(' ', popup_width - 10 - #mapping - #key)
                .. key
                .. ' │'
            )

            table.insert(section_lines, line_nr)
            line_nr = line_nr + 1
          else
            if type(key[1]) == 'string' then
              key[1] = parse_mapping(key[1])
              table.insert(
                lines,
                spaces(spacing)
                  .. '│ '
                  .. format(mapping)
                  .. string.rep(
                    ' ',
                    popup_width - 10 - #mapping - #key[1]
                  )
                  .. key[1]
                  .. ' │'
              )

              table.insert(section_lines, line_nr)
              line_nr = line_nr + 1
            elseif type(key) == 'table' then
              table.insert(
                lines,
                spaces(spacing)
                  .. '│ '
                  .. format(mapping)
                  .. ':'
                  .. string.rep(' ', popup_width - 10 - #mapping)
                  .. '│'
              )
              table.insert(section_lines, line_nr)
              line_nr = line_nr + 1

              for mapping_name, keystroke in pairs(key) do
                keystroke = parse_mapping(keystroke)
                table.insert(
                  lines,
                  spaces(spacing)
                    .. '│ '
                    .. format(mapping_name)
                    .. string.rep(
                      ' ',
                      popup_width - 10 - #mapping_name - 2 - #keystroke
                    )
                    .. keystroke
                    .. ' │'
                )

                table.insert(section_lines, line_nr)
                line_nr = line_nr + 1
              end
            end
          end
        end

        table.insert(
          lines,
          spaces(spacing)
            .. '└'
            .. string.rep('─', popup_width - 8)
            .. '┘'
        )
        table.insert(border_lines, line_nr)

        line_nr = line_nr + 1
        table.insert(lines, ' ')
        line_nr = line_nr + 1
      else
        lines[#lines + 1] = ' '
        line_nr = line_nr + 1
        table.insert(
          lines,
          spaces(spacing)
            .. '│'
            .. format(Title)
            .. string.rep(' ', popup_width - 9 - #Title - #values)
            .. values
            .. ' '
        )

        table.insert(section_lines, line_nr)
        line_nr = line_nr + 1

        table.insert(
          lines,
          spaces(spacing)
            .. '└'
            .. string.rep('─', popup_width - 8)
            .. '┘'
        )
        table.insert(section_lines, line_nr)
        line_nr = line_nr + 1
      end
    end
  end
  buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    'q',
    '<cmd>q<CR>',
    { noremap = true, silent = true, nowait = true }
  )
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = popup_width,
    height = math.floor(height * 0.8),
    col = math.floor(width * 0.3),
    row = math.floor(height * 0.1),
    border = 'rounded',
    style = 'minimal',
  })

  vim.api.nvim_buf_set_option(buf, 'filetype', 'cheatsheet')
  vim.api.nvim_win_set_option(win, 'wrap', false)

  local highlight_nr = 1

  for _, line in ipairs(heading_lines) do
    if true then
      highlight_nr = highlight_nr + 1
      add_highlight(
        buf,
        ns,
        'CheatsheetTitle' .. highlight_nr,
        line,
        spacing >= 4 and spacing or 0,
        -1
      )

      if highlight_nr == 6 then
        highlight_nr = 1
      end
    end
  end

  for _, line in ipairs(section_lines) do
    add_highlight(buf, ns, 'CheatsheetSectionContent', line, spacing, -1)
  end

  for _, line in ipairs(border_lines) do
    add_highlight(buf, ns, 'CheatsheetBorder', line, spacing, -1)
  end

  for _, line in ipairs(section_lines) do
    add_highlight(buf, ns, 'CheatsheetBorder', line, spacing + 2, spacing + 3)
    add_highlight(
      buf,
      ns,
      'CheatsheetBorder',
      line,
      spacing + popup_width - 5,
      spacing + popup_width - 2
    )
  end

  for _, line in ipairs(section_titles) do
    add_highlight(buf, ns, 'CheatsheetHeading', line - 1, 1, -1)
  end

  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

M.show = function(mappings)
  -- Lua is copy by reference so make a deep copy of the table
  local pluginMappings = mappings.plugins
  mappings.plugins = nil

  display_cheatsheet {
    ['Plugin Mappings'] = pluginMappings,
    ['Normal mappings'] = mappings,
  }
end

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
    themes = '<leader>th', -- NvChad theme picker
  },
}

return M
