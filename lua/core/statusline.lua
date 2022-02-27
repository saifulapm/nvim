local utils = require 'utils.statusline'

--- @param statusline table
--- @param available_space number
local function display(statusline, available_space)
  local str = ''
  local items = utils.prioritize(statusline, available_space)
  for _, item in ipairs(items) do
    if type(item.component) == 'string' then
      str = str .. item.component
    end
  end
  return str
end

--- @param tbl table
--- @param next string
--- @param priority table
local function append(tbl, next, priority)
  priority = priority or 0
  local component, length = unpack(next)
  if component and component ~= '' and next and tbl then
    table.insert(tbl, { component = component, priority = priority, length = length })
  end
end

---Aggregate pieces of the statusline
---@param tbl table
---@return function
local function make_status(tbl)
  return function(...)
    for i = 1, select('#', ...) do
      local item = select(i, ...)
      append(tbl, unpack(item))
    end
  end
end

local separator = { '%=' }
local end_marker = { '%<' }

local item = utils.item
local item_if = utils.item_if

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function _G.__statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)

  local available_space = vim.api.nvim_win_get_width(curwin)

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = vim.fn.bufname(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab,
  }

  local plain = utils.is_plain(ctx)
  local file_modified = utils.modified(ctx, '●')
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused
  local markdown_type = ctx.buftype == 'markdown' or false

  local statusline = {}
  local add = make_status(statusline)

  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local segments = utils.file(ctx, minimal)
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local dir_item = utils.item(dir.item, dir.hl, dir.opts)
  local parent_item = utils.item(parent.item, parent.hl, parent.opts)
  local file_item = utils.item(file.item, file.hl, file.opts)
  local readonly_item = utils.item(utils.readonly(ctx), 'StError')

  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if minimal then
    add(
      { item('▌', 'StIndicator', { before = '', after = '' }), 0 },
      { utils.spacer(1), 0 },
      { readonly_item, 1 },
      { dir_item, 3 },
      { parent_item, 2 },
      { file_item, 0 }
    )
    return display(statusline, available_space)
  end

  local status = vim.b.gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -- LSP Diagnostics
  local diagnostics = utils.diagnostic_info(ctx)
  local flutter = vim.g.flutter_tools_decorations or {}

  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    { item(utils.mode()), 0 },
    {
      item(
        status.head and status.head .. ' ',
        'StGit',
        { prefix = ' ', prefix_color = 'StGit', after = '' }
      ),
      1,
    },
    { utils.spacer(1), 0 },
    { readonly_item, 2 },
    { dir_item, 3 },
    { parent_item, 2 },
    { file_item, 0 },
    { item_if(file_modified, ctx.modified, 'StModified', { before = ' ' }), 1 },
    { item_if('Saving…', vim.g.is_saving, 'StComment', { before = ' ' }), 1 },
    -- LSP Status
    {
      item(utils.current_function(), 'StMetadata', {
        before = '  ',
        prefix = '',
        prefix_color = 'StIdentifier',
      }),
      4,
    },
    { separator },
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//

    { separator },

    -----------------------------------------------------------------------------//
    -- Right section
    -----------------------------------------------------------------------------//
    { item(flutter.app_version, 'StMetadata'), 4 },
    { item(flutter.device and flutter.device.name or '', 'StMetadata'), 4 },
    { item(utils.lsp_client(), 'StMetadata'), 4 },
    {
      item_if(diagnostics.error.count, diagnostics.error, 'StError', {
        prefix = diagnostics.error.sign,
      }),
      1,
    },
    {
      item_if(diagnostics.warning.count, diagnostics.warning, 'StWarning', {
        prefix = diagnostics.warning.sign,
      }),
      3,
    },
    {
      item_if(diagnostics.info.count, diagnostics.info, 'StInfo', {
        prefix = diagnostics.info.sign,
      }),
      4,
    },
    -- Git Status
    { item(status.changed, 'StTitle', { prefix = '', prefix_color = 'StWarning' }), 3 },
    { item(status.removed, 'StTitle', { prefix = '', prefix_color = 'StError' }), 3 },
    { item(status.added, 'StTitle', { prefix = '', prefix_color = 'StGreen' }), 3 },
    {
      item(
        ahead,
        'StTitle',
        { prefix = '⇡', prefix_color = 'StGreen', after = behind > 0 and '' or ' ', before = '' }
      ),
      5,
    },
    { item(behind, 'StTitle', { prefix = '⇣', prefix_color = 'StNumber', after = ' ' }), 5 },
    -- Word count for MD
    { item_if(utils.count_words(), markdown_type, 'StIndicator'), 1 },
    -- Current line number/total line number,  alternatives 
    {
      utils.line_info {
        prefix = 'ℓ',
        prefix_color = 'StMetadataPrefix',
        current_hl = 'StTitle',
        total_hl = 'StComment',
        sep_hl = 'StComment',
      },
      7,
    },
    -- (Unexpected) Indentation
    {
      item_if(ctx.shiftwidth, ctx.shiftwidth > 2 or not ctx.expandtab, 'StTitle', {
        prefix = ctx.expandtab and 'Ξ' or '⇥',
        prefix_color = 'StatusLine',
      }),
      6,
    },
    -- Scrollbar
    { item(utils.ScrollBar()), 7 },
    { end_marker }
  )

  -- removes 5 columns to add some padding
  return display(statusline, available_space - 5)
end

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%!v:lua.__statusline()'
