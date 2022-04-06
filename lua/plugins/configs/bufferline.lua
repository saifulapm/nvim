local present, bufferline = pcall(require, 'bufferline')
if not present then
  return
end

local fn = vim.fn

local function diagnostics_indicator(_, _, diagnostics)
  local symbols = {
    error = G.style.icons.error,
    warning = G.style.icons.warn,
    info = G.style.icons.info,
  }
  local result = {}
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. count)
    end
  end
  result = table.concat(result, ' ')
  return #result > 0 and result or ''
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return vim.bo[b].filetype == 'log'
  end, buf_nums)
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr '$'
  local is_log = vim.bo[buf].filetype == 'log'
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

local groups = require 'bufferline.groups'

bufferline.setup {
  options = {
    mode = 'buffers', -- tabs
    sort_by = 'insert_after_current',
    buffer_close_icon = '',
    modified_icon = '',
    show_close_icon = false,
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 20,
    show_tab_indicators = true,
    enforce_regular_tabs = false,
    view = 'multiwindow',
    show_buffer_close_icons = true,
    separator_style = 'thin',
    always_show_bufferline = true,
    diagnostics = false,
    diagnostics_indicator = diagnostics_indicator,
    diagnostics_update_in_insert = true,
    custom_filter = custom_filter,
    offsets = {
      {
        filetype = 'undotree',
        text = 'Undotree',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'NvimTree',
        text = 'פּ Files',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'neo-tree',
        text = 'Explorer',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'DiffviewFiles',
        text = 'Diff View',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'flutterToolsOutline',
        text = 'Flutter Outline',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'packer',
        text = 'Packer',
        highlight = 'PanelHeading',
        padding = 1,
      },
    },
    groups = {
      options = {
        toggle_hidden_on_enter = true,
      },
      items = {
        groups.builtin.ungrouped,
        {
          highlight = { guisp = '#51AFEF', gui = 'underline' },
          name = 'tests',
          icon = '',
          matcher = function(buf)
            return buf.filename:match '_spec' or buf.filename:match 'test'
          end,
        },
        {
          name = 'view models',
          highlight = { guisp = '#03589C', gui = 'underline' },
          matcher = function(buf)
            return buf.filename:match 'view_model%.dart'
          end,
        },
        {
          name = 'screens',
          matcher = function(buf)
            return buf.path:match 'screen'
          end,
        },
        {
          highlight = { guisp = '#C678DD', gui = 'underline' },
          name = 'docs',
          auto_close = true,
          matcher = function(buf)
            for _, ext in ipairs { 'md', 'txt', 'org', 'norg', 'wiki' } do
              if ext == fn.fnamemodify(buf.path, ':e') then
                return true
              end
            end
          end,
        },
      },
    },
  },
  highlights = {
    fill = {
      guibg = 'Background',
    },
  },
}
