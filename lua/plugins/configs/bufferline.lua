require('colors').load_highlight 'bufferline'

local fn = vim.fn
local fmt = string.format

local groups = require 'bufferline.groups'

require('bufferline').setup {
  highlights = {
    info = { gui = 'undercurl' },
    info_selected = { gui = 'undercurl' },
    info_visible = { gui = 'undercurl' },
    warning = { gui = 'undercurl' },
    warning_selected = { gui = 'undercurl' },
    warning_visible = { gui = 'undercurl' },
    error = { gui = 'undercurl' },
    error_selected = { gui = 'undercurl' },
    error_visible = { gui = 'undercurl' },
  },
  options = {
    debug = {
      logging = true,
    },
    navigation = { mode = 'uncentered' },
    mode = 'buffers', -- tabs
    sort_by = 'insert_after_current',
    right_mouse_command = 'vert sbuffer %d',
    show_close_icon = false,
    show_buffer_close_icons = true,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = false,
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = 'pr',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'dbui',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'undotree',
        text = 'Undotree',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'NvimTree',
        text = 'Explorer',
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
    groups = {
      options = {
        toggle_hidden_on_enter = true,
      },
      items = {
        groups.builtin.pinned:with { icon = '' },
        groups.builtin.ungrouped,
        {
          name = 'Dependencies',
          highlight = { guifg = '#ECBE7B' },
          matcher = function(buf)
            return vim.startswith(buf.path, fmt('%s/site/pack/packer', fn.stdpath 'data'))
              or vim.startswith(buf.path, fn.expand '$VIMRUNTIME')
          end,
        },
        {
          name = 'Terraform',
          matcher = function(buf)
            return buf.name:match '%.tf' ~= nil
          end,
        },
        {
          name = 'SQL',
          matcher = function(buf)
            return buf.filename:match '%.sql$'
          end,
        },
        {
          name = 'tests',
          icon = '',
          matcher = function(buf)
            local name = buf.filename
            if name:match '%.sql$' == nil then
              return false
            end
            return name:match '_spec' or name:match '_test'
          end,
        },
        {
          name = 'docs',
          icon = '',
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
}
