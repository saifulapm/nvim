local present, bufferline = pcall(require, 'bufferline')
if not present then
  return
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
    diagnostics_update_in_insert = true,
    custom_filter = custom_filter,
    offsets = {
      {
        filetype = 'undotree',
        text = 'Undotree',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'NvimTree',
        text = 'פּ Files',
        highlight = 'PanelHeading',
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
      },
      {
        filetype = 'flutterToolsOutline',
        text = 'Flutter Outline',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'Outline',
        text = 'Symbols',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'packer',
        text = 'Packer',
        highlight = 'PanelHeading',
      },
    },
    themable = false,
  },
}
