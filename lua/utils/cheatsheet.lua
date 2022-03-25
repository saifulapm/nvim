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
    mapping = string.gsub(mapping, 'A%-', 'Alt+')
    mapping = string.gsub(mapping, 'a%-', 'Alt+')
    mapping = string.gsub(mapping, '%<leader%>', 'Leader+')
    mapping = string.gsub(mapping, '%<localleader%>', 'LocalLeader+')
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
    table.insert(lines, spaces(math.floor(width * 0.4 / 2) - math.floor(#main_sec / 2)) .. main_sec)

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

        table.insert(lines, spaces(spacing) .. '┌' .. string.rep('─', popup_width - 8) .. '┐')
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
                  .. string.rep(' ', popup_width - 10 - #mapping - #key[1])
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
                    .. string.rep(' ', popup_width - 10 - #mapping_name - 2 - #keystroke)
                    .. keystroke
                    .. ' │'
                )

                table.insert(section_lines, line_nr)
                line_nr = line_nr + 1
              end
            end
          end
        end

        table.insert(lines, spaces(spacing) .. '└' .. string.rep('─', popup_width - 8) .. '┘')
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

        table.insert(lines, spaces(spacing) .. '└' .. string.rep('─', popup_width - 8) .. '┘')
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
    border = G.style.border.line,
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

return M
