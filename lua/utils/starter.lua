-- From: https://github.com/echasnovski/mini.nvim#ministarter
local M = {}
local H = {}
local sessions = require 'utils.session'

--- Module config
M.config = {
  autoopen = true,
  evaluate_single = false,
  items = nil,
  header = nil,
  footer = nil,
  content_hooks = nil,
  query_updaters = [[abcdefghijklmnopqrstuvwxyz0123456789_-.]],
}

M.content = {}

--- Act on |VimEnter|.
function M.on_vimenter()
  if M.config.autoopen and not H.is_to_autoopen() then
    -- Use current buffer as it should be empty and not needed. This also
    -- solves the issue of redundant buffer when opening a file from Starter.
    M.open(vim.api.nvim_get_current_buf())
  end
end

--- Open Starter buffer
function M.open(buf_id)
  -- Reset helper data
  H.current_item_id = 1
  H.query = ''

  -- Ensure proper buffer and open it
  if buf_id == nil or not vim.api.nvim_buf_is_valid(buf_id) then
    buf_id = vim.api.nvim_create_buf(false, true)
  end
  H.buf_id = buf_id
  vim.api.nvim_set_current_buf(H.buf_id)

  -- Setup buffer behavior
  H.apply_buffer_options()
  H.apply_buffer_mappings()
  vim.cmd [[au VimResized <buffer> lua require('utils.starter').refresh()]]
  vim.cmd [[au CursorMoved <buffer> lua require('utils.starter').on_cursormoved()]]
  vim.cmd [[au BufLeave <buffer> echo '']]

  -- Populate buffer
  M.refresh()
end

--- Refresh Starter buffer
function M.refresh()
  if H.buf_id == nil or not vim.api.nvim_buf_is_valid(H.buf_id) then
    return
  end

  -- Normalize certain config values
  local items = H.normalize_items(M.config.items or H.default_items)
  H.header = H.normalize_header_footer(M.config.header or H.default_header, 'header')
  H.footer = H.normalize_header_footer(M.config.footer or H.default_footer, 'footer')

  -- Evaluate content
  H.make_initial_content(items)
  local hooks = M.config.content_hooks or H.default_content_hooks
  for _, f in ipairs(hooks) do
    M.content = f(M.content)
  end
  H.items = M.content_to_items()

  -- Add content
  vim.api.nvim_buf_set_option(H.buf_id, 'modifiable', true)
  vim.api.nvim_buf_set_lines(H.buf_id, 0, -1, false, M.content_to_lines())
  vim.api.nvim_buf_set_option(H.buf_id, 'modifiable', false)

  -- Add highlighting
  H.content_highlight()
  H.items_highlight()

  -- -- Always position cursor on current item
  H.position_cursor_on_current_item()
  H.add_hl_current_item()

  -- Apply current query (clear command line afterwards)
  H.make_query()
end

--- Close Starter buffer
function M.close()
  vim.api.nvim_buf_delete(H.buf_id, {})
  H.buf_id = nil
end

-- Sections -------------------------------------------------------------------
--- Table of pre-configured sections
M.sections = {}

--- Section with builtin actions
function M.sections.builtin_actions()
  return {
    { name = 'Edit new buffer', action = 'enew', section = 'Builtin actions' },
    { name = 'Quit Neovim', action = 'qall', section = 'Builtin actions' },
  }
end

function M.normalize_name(name)
  return string.match(name:gsub('%%', '_'):gsub('%.%w+', ''), '_(%w+)$'):gsub('^%l', string.upper)
end

--- Section with sessions
function M.sections.sessions(n, recent)
  n = n or 5
  recent = recent == nil and true or recent

  return function()
    local items = {}
    for session_name, session in pairs(sessions.list()) do
      table.insert(items, {
        _session = session,
        name = M.normalize_name(session_name),
        action = ([[lua require('utils.session').load('%s')]]):format(session_name),
        section = 'Sessions',
      })
    end

    if vim.tbl_count(items) == 0 then
      return {
        {
          name = [[There are no detected sessions in 'Starter']],
          action = '',
          section = 'Sessions',
        },
      }
    end

    local sort_fun
    if recent then
      sort_fun = function(a, b)
        local a_time = a._session.type == 'local' and math.huge or a._session.modify_time
        local b_time = b._session.type == 'local' and math.huge or b._session.modify_time
        return a_time > b_time
      end
    else
      sort_fun = function(a, b)
        local a_name = a._session.type == 'local' and '' or a.name
        local b_name = b._session.type == 'local' and '' or b.name
        return a_name < b_name
      end
    end
    table.sort(items, sort_fun)

    -- Take only first `n` elements and remove helper fields
    return vim.tbl_map(function(x)
      x._session = nil
      return x
    end, vim.list_slice(items, 1, n))
  end
end

--- Section with most recently used files
function M.sections.recent_files(n, current_dir, show_path)
  n = n or 5
  current_dir = current_dir == nil and false or current_dir
  show_path = show_path == nil and true or show_path

  if current_dir then
    vim.cmd [[au DirChanged * lua require('utils.starter').refresh()]]
  end

  return function()
    local section = ('Recent files%s'):format(current_dir and ' (current directory)' or '')

    -- Use only actual readable files
    local files = vim.tbl_filter(function(f)
      return vim.fn.filereadable(f) == 1
    end, vim.v.oldfiles or {})

    if #files == 0 then
      return {
        {
          name = [[There are no recent files (`v:oldfiles` is empty)]],
          action = '',
          section = section,
        },
      }
    end

    -- Possibly filter files from current directory
    if current_dir then
      local cwd = vim.loop.cwd()
      local n_cwd = cwd:len()
      files = vim.tbl_filter(function(f)
        return f:sub(1, n_cwd) == cwd
      end, files)
    end

    if #files == 0 then
      return {
        {
          name = [[There are no recent files in current directory]],
          action = '',
          section = section,
        },
      }
    end

    -- Create items
    local items = {}
    local fmodify = vim.fn.fnamemodify
    for _, f in ipairs(vim.list_slice(files, 1, n)) do
      local path = show_path and (' (%s)'):format(fmodify(f, ':~:.')) or ''
      local name = ('%s%s'):format(fmodify(f, ':t'), path)
      table.insert(
        items,
        { action = ('edit %s'):format(fmodify(f, ':p')), name = name, section = section }
      )
    end

    return items
  end
end

--- Section with basic Telescope pickers relevant to start screen
function M.sections.telescope()
  return function()
    return {
      { action = 'Telescope file_browser', name = 'Browser', section = 'Telescope' },
      { action = 'Telescope command_history', name = 'Command history', section = 'Telescope' },
      { action = 'Telescope find_files', name = 'Files', section = 'Telescope' },
      { action = 'Telescope help_tags', name = 'Help tags', section = 'Telescope' },
      { action = 'Telescope live_grep', name = 'Live grep', section = 'Telescope' },
      { action = 'Telescope oldfiles', name = 'Old files', section = 'Telescope' },
    }
  end
end

-- Content hooks --------------------------------------------------------------
M.gen_hook = {}

--- Hook generator for padding
function M.gen_hook.padding(left, top)
  left = math.max(left or 0, 0)
  top = math.max(top or 0, 0)
  return function(content)
    -- Add left padding
    local left_pad = string.rep(' ', left)
    for _, line in ipairs(content) do
      table.insert(line, 1, H.content_unit(left_pad, 'empty', nil))
    end

    -- Add top padding
    local top_lines = {}
    for _ = 1, top do
      table.insert(top_lines, { H.content_unit('', 'empty', nil) })
    end
    content = vim.list_extend(top_lines, content)

    return content
  end
end

--- Hook generator for adding bullet to items
function M.gen_hook.adding_bullet(bullet, place_cursor)
  bullet = bullet or '░ '
  place_cursor = place_cursor == nil and true or place_cursor
  return function(content)
    local coords = M.content_coords(content, 'item')
    -- Go backwards to avoid conflict when inserting units
    for i = #coords, 1, -1 do
      local l_num, u_num = coords[i].line, coords[i].unit
      local bullet_unit = {
        string = bullet,
        type = 'item_bullet',
        hl = 'StarterItemBullet',
        -- Use `_item` instead of `item` because it is better to be 'private'
        _item = content[l_num][u_num].item,
        _place_cursor = place_cursor,
      }
      table.insert(content[l_num], u_num, bullet_unit)
    end

    return content
  end
end

--- Hook generator for indexing items
function M.gen_hook.indexing(grouping, exclude_sections)
  grouping = grouping or 'all'
  exclude_sections = exclude_sections or {}
  local per_section = grouping == 'section'

  return function(content)
    local cur_section, n_section, n_item = nil, 0, 0
    local coords = M.content_coords(content, 'item')

    for _, c in ipairs(coords) do
      local unit = content[c.line][c.unit]
      local item = unit.item

      if not vim.tbl_contains(exclude_sections, item.section) then
        n_item = n_item + 1
        if cur_section ~= item.section then
          cur_section = item.section
          -- Cycle through lower case letters
          n_section = math.fmod(n_section, 26) + 1
          n_item = per_section and 1 or n_item
        end

        local section_index = per_section and string.char(96 + n_section) or ''
        unit.string = ('%s%s. %s'):format(section_index, n_item, unit.string)
      end
    end

    return content
  end
end

--- Hook generator for aligning content
function M.gen_hook.aligning(horizontal, vertical)
  horizontal = horizontal == nil and 'left' or horizontal
  vertical = vertical == nil and 'top' or vertical

  local horiz_coef = ({ left = 0, center = 0.5, right = 1.0 })[horizontal]
  local vert_coef = ({ top = 0, center = 0.5, bottom = 1.0 })[vertical]

  return function(content)
    local line_strings = M.content_to_lines(content)

    -- Align horizontally
    -- Don't use `string.len()` to account for multibyte characters
    local lines_width = vim.tbl_map(function(l)
      return vim.fn.strdisplaywidth(l)
    end, line_strings)
    local min_right_space = vim.fn.winwidth(0) - math.max(unpack(lines_width))
    local left_pad = math.max(math.floor(horiz_coef * min_right_space), 0)

    -- Align vertically
    local bottom_space = vim.fn.winheight(0) - #line_strings
    local top_pad = math.max(math.floor(vert_coef * bottom_space), 0)

    return M.gen_hook.padding(left_pad, top_pad)(content)
  end
end

-- Work with content ----------------------------------------------------------
function M.content_coords(content, predicate)
  content = content or M.content
  if type(predicate) == 'string' then
    local pred_type = predicate
    predicate = function(unit)
      return unit.type == pred_type
    end
  end

  local res = {}
  for l_num, line in ipairs(content) do
    for u_num, unit in ipairs(line) do
      if predicate == nil or predicate(unit) then
        table.insert(res, { line = l_num, unit = u_num })
      end
    end
  end
  return res
end

--- Convert content to buffer lines
function M.content_to_lines(content)
  return vim.tbl_map(function(content_line)
    return table.concat(
      -- Ensure that each content line is indeed a single buffer line
      vim.tbl_map(function(x)
        return x.string:gsub('\n', ' ')
      end, content_line),
      ''
    )
  end, content or M.content)
end

--- Convert content to items
function M.content_to_items(content)
  content = content or M.content

  -- NOTE: this havily utilizes 'modify by reference' nature of Lua tables
  local items = {}
  for l_num, line in ipairs(content) do
    -- Track 0-based starting column of current unit (using byte length)
    local start_col = 0
    for _, unit in ipairs(line) do
      -- Cursor position is (1, 0)-based
      local cursorpos = { l_num, start_col }

      if unit.type == 'item' then
        local item = unit.item
        -- Take item's name from content string
        item.name = unit.string:gsub('\n', ' ')
        item._line = l_num - 1
        item._start_col = start_col
        item._end_col = start_col + unit.string:len()
        -- Don't overwrite possible cursor position from item's bullet
        item._cursorpos = item._cursorpos or cursorpos

        table.insert(items, item)
      end

      -- Prefer placing cursor at start of item's bullet
      if unit.type == 'item_bullet' and unit._place_cursor then
        -- Item bullet uses 'private' `_item` element instead of `item`
        unit._item._cursorpos = cursorpos
      end

      start_col = start_col + unit.string:len()
    end
  end

  -- Compute length of unique prefix for every item's name (ignoring case)
  local strings = vim.tbl_map(function(x)
    return x.name:lower()
  end, items)
  local nprefix = H.unique_nprefix(strings)
  for i, n in ipairs(nprefix) do
    items[i]._nprefix = n
  end

  return items
end

--- Evaluate current item
function M.eval_current_item()
  H.eval_fun_or_string(H.items[H.current_item_id].action, true)
end

--- Update current item
function M.update_current_item(direction)
  -- Advance current item
  local prev_current = H.current_item_id
  H.current_item_id = H.next_active_item_id(H.current_item_id, direction)
  if H.current_item_id == prev_current then
    return
  end

  -- Update cursor position
  H.position_cursor_on_current_item()

  -- Highlight current item
  vim.api.nvim_buf_clear_namespace(H.buf_id, H.ns.current_item, 0, -1)
  H.add_hl_current_item()
end

--- Add character to current query
function M.add_to_query(char)
  if char == nil then
    H.query = H.query:sub(0, H.query:len() - 1)
  else
    H.query = ('%s%s'):format(H.query, char)
  end
  H.make_query()
end

--- Set current query
function M.set_query(query)
  query = query or ''
  if type(query) ~= 'string' then
    H.notify '`query` should be either `nil` or string.'
  end

  H.query = query
  H.make_query()
end

--- Act on |CursorMoved| by repositioning cursor in fixed place.
function M.on_cursormoved()
  H.position_cursor_on_current_item()
end

-- Helper data ================================================================
-- Module default config
H.default_config = M.config

-- Default config values
H.default_items = {
  function()
    return M.sections.sessions(5, true)()
  end,
  M.sections.recent_files(5, false, false),
  M.sections.builtin_actions(),
}

H.default_header = function()
  local hour = tonumber(vim.fn.strftime '%H')
  -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
  local part_id = math.floor((hour + 4) / 8) + 1
  local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
  local username = vim.loop.os_get_passwd()['username'] or 'USERNAME'

  return ('Good %s, %s'):format(day_part, username:gsub('^%l', string.upper))
end

H.default_footer = [[
Type query to filter items
<BS> deletes latest character from query
<Esc> resets current query
<Down>/<Up> and <M-j>/<M-k> move current item
<CR> executes action of current item
<C-c> closes this buffer]]

H.default_content_hooks = { M.gen_hook.adding_bullet(), M.gen_hook.aligning('center', 'center') }

-- Normalized values from config
H.items = {} -- items gathered with `M.content_to_items` from final content
H.header = {} -- table of strings
H.footer = {} -- table of strings

-- Identifier of current item
H.current_item_id = nil

-- Buffer identifier where everything is displayed
H.buf_id = nil

-- Namespaces for highlighting
H.ns = {
  activity = vim.api.nvim_create_namespace '',
  current_item = vim.api.nvim_create_namespace '',
  general = vim.api.nvim_create_namespace '',
}

-- Current search query
H.query = ''

-- Normalize config elements --------------------------------------------------
function H.normalize_items(items)
  local res = H.items_flatten(items)
  if #res == 0 then
    return { { name = '`M.config.items` is empty', action = '', section = '' } }
  end
  return H.items_sort(res)
end

function H.normalize_header_footer(x, x_name)
  local res = H.eval_fun_or_string(x)
  if type(res) ~= 'string' then
    H.notify(('`config.%s` should be evaluated into string.'):format(x_name))
    return {}
  end
  if res == '' then
    return {}
  end
  return vim.split(res, '\n')
end

-- Work with buffer content ---------------------------------------------------
function H.make_initial_content(items)
  M.content = {}

  -- Add header lines
  for _, l in ipairs(H.header) do
    H.content_add_line { H.content_unit(l, 'header', 'StarterHeader') }
  end
  H.content_add_empty_lines(#H.header > 0 and 1 or 0)

  -- Add item lines
  H.content_add_items(items)

  -- Add footer lines
  H.content_add_empty_lines(#H.footer > 0 and 1 or 0)
  for _, l in ipairs(H.footer) do
    H.content_add_line { H.content_unit(l, 'footer', 'StarterFooter') }
  end
end

function H.content_unit(string, type, hl, extra)
  return vim.tbl_extend('force', { string = string, type = type, hl = hl }, extra or {})
end

function H.content_add_line(content_line)
  table.insert(M.content, content_line)
end

function H.content_add_empty_lines(n)
  for _ = 1, n do
    H.content_add_line { H.content_unit('', 'empty', nil) }
  end
end

function H.content_add_items(items)
  local cur_section
  for _, item in ipairs(items) do
    -- Possibly add section line
    if cur_section ~= item.section then
      -- Don't add empty line before first section line
      H.content_add_empty_lines(cur_section == nil and 0 or 1)
      H.content_add_line { H.content_unit(item.section, 'section', 'StarterSection') }
      cur_section = item.section
    end

    H.content_add_line { H.content_unit(item.name, 'item', 'StarterItem', { item = item }) }
  end
end

function H.content_highlight()
  for l_num, content_line in ipairs(M.content) do
    -- Track 0-based starting column of current unit (using byte length)
    local start_col = 0
    for _, unit in ipairs(content_line) do
      if unit.hl ~= nil then
        H.buf_hl(H.ns.general, unit.hl, l_num - 1, start_col, start_col + unit.string:len())
      end
      start_col = start_col + unit.string:len()
    end
  end
end

-- Work with items -----------------------------------------------------------
function H.items_flatten(items)
  local res, f = {}, nil
  f = function(x)
    if H.is_item(x) then
      -- Use deepcopy to allow adding fields to items without changing original
      table.insert(res, vim.deepcopy(x))
      return
    end

    -- Expand (possibly recursively) functions immediately
    local n_nested = 0
    while type(x) == 'function' do
      n_nested = n_nested + 1
      if n_nested > 100 then
        H.notify 'Too many nested functions in `config.items`.'
      end
      x = x()
    end

    if type(x) ~= 'table' then
      return
    end
    return vim.tbl_map(f, x)
  end

  f(items)
  return res
end

function H.items_sort(items)
  -- Order first by section and then by item id (both in order of appearence)
  -- Gather items grouped per section in order of their appearence
  local sections, section_order = {}, {}
  for _, item in ipairs(items) do
    local sec = item.section
    if section_order[sec] == nil then
      table.insert(sections, {})
      section_order[sec] = #sections
    end
    table.insert(sections[section_order[sec]], item)
  end

  -- Unroll items in depth-first fashion
  local res = {}
  for _, section_items in ipairs(sections) do
    for _, item in ipairs(section_items) do
      table.insert(res, item)
    end
  end

  return res
end

function H.items_highlight()
  for _, item in ipairs(H.items) do
    H.buf_hl(
      H.ns.general,
      'StarterItemPrefix',
      item._line,
      item._start_col,
      item._start_col + item._nprefix
    )
  end
end

function H.next_active_item_id(item_id, direction)
  -- Advance in cyclic fashion
  local id = item_id
  local n_items = vim.tbl_count(H.items)
  local increment = direction == 'next' and 1 or (n_items - 1)

  -- Increment modulo `n` but for 1-based indexing
  id = math.fmod(id + increment - 1, n_items) + 1
  while not (H.items[id]._active or id == item_id) do
    id = math.fmod(id + increment - 1, n_items) + 1
  end

  return id
end

function H.position_cursor_on_current_item()
  vim.api.nvim_win_set_cursor(0, H.items[H.current_item_id]._cursorpos)
end

-- Work with queries ----------------------------------------------------------
function H.make_query(query)
  -- Ignore case
  query = (query or H.query):lower()

  -- Item is active = item's name starts with query (ignoring case) and item's
  -- action is non-empty
  local n_active = 0
  for _, item in ipairs(H.items) do
    item._active = vim.startswith(item.name:lower(), query) and item.action ~= ''
    n_active = n_active + (item._active and 1 or 0)
  end

  -- Move to next active item if current is not active
  if not H.items[H.current_item_id]._active then
    M.update_current_item 'next'
  end

  -- Update activity highlighting. This should go before `evaluate_single`
  -- check because evaluation might not result into closing Starter buffer
  vim.api.nvim_buf_clear_namespace(H.buf_id, H.ns.activity, 0, -1)
  H.add_hl_activity(query)

  -- Possibly evaluate single active item
  if M.config.evaluate_single and n_active == 1 then
    M.eval_current_item()
    return
  end

  -- Notify about new query
  local msg = ('Query: %s'):format(H.query)
  if n_active == 0 then
    msg = ('%s . There is no active items. Use <BS> to delete symbols from query.'):format(msg)
  end
  -- Use `echo` because it doesn't write to `:messages`
  vim.cmd(([[echo '(Starter) %s']]):format(vim.fn.escape(msg, [[']])))
end

-- Work with starter buffer ---------------------------------------------------
function H.apply_buffer_options()
  -- Force Normal mode
  vim.cmd [[normal! <ESC>]]

  vim.api.nvim_buf_set_name(H.buf_id, 'Starter')
  -- Having `noautocmd` is crucial for performance: ~9ms without it, ~1.6ms with it
  vim.cmd [[noautocmd silent! set filetype=starter]]

  local options = {
    [[bufhidden=wipe]],
    [[colorcolumn=]],
    [[foldcolumn=0]],
    [[matchpairs=]],
    [[nobuflisted]],
    [[nocursorcolumn]],
    [[nocursorline]],
    [[nolist]],
    [[nonumber]],
    [[noreadonly]],
    [[norelativenumber]],
    [[nospell]],
    [[noswapfile]],
    [[signcolumn=no]],
    [[synmaxcol&]],
    [[buftype=nofile]],
    [[nomodeline]],
    [[nomodifiable]],
    [[foldlevel=999]],
  }
  -- Vim's `setlocal` is currently more robust comparing to `opt_local`
  vim.cmd(('silent! noautocmd setlocal %s'):format(table.concat(options, ' ')))

  -- Hide tabline on single tab by setting `showtabline` to default value (but
  -- not statusline as it weirdly feels 'naked' without it). Restore previous
  -- value on buffer leave if wasn't changed (like in tabline plugin to 2).
  vim.cmd(
    ('au BufLeave <buffer> if &showtabline==1 | set showtabline=%s | endif'):format(
      vim.o.showtabline
    )
  )
  vim.cmd(
    ('au BufLeave <buffer> if &laststatus==0 | set laststatus=%s | endif'):format(vim.o.laststatus)
  )
  vim.o.showtabline = 1
  vim.o.laststatus = 0
end

function H.apply_buffer_mappings()
  H.buf_keymap('<CR>', [[require('utils.starter').eval_current_item()]])

  H.buf_keymap('<Up>', [[require('utils.starter').update_current_item('prev')]])
  H.buf_keymap('<M-k>', [[require('utils.starter').update_current_item('prev')]])
  H.buf_keymap('<Down>', [[require('utils.starter').update_current_item('next')]])
  H.buf_keymap('<M-j>', [[require('utils.starter').update_current_item('next')]])

  -- Make all special symbols to update query
  for _, key in ipairs(vim.split(M.config.query_updaters, '')) do
    H.buf_keymap(key, ([[require('utils.starter').add_to_query('%s')]]):format(key))
  end

  H.buf_keymap('<Esc>', [[require('utils.starter').set_query('')]])
  H.buf_keymap('<BS>', [[require('utils.starter').add_to_query()]])
  H.buf_keymap('<C-c>', [[require('utils.starter').close()]])
end

function H.add_hl_activity(query)
  for _, item in ipairs(H.items) do
    local l = item._line
    local s = item._start_col
    local e = item._end_col
    if item._active then
      H.buf_hl(H.ns.activity, 'StarterQuery', l, s, s + query:len())
    else
      H.buf_hl(H.ns.activity, 'StarterInactive', l, s, e)
    end
  end
end

function H.add_hl_current_item()
  local cur_item = H.items[H.current_item_id]
  H.buf_hl(
    H.ns.current_item,
    'StarterCurrent',
    cur_item._line,
    cur_item._start_col,
    cur_item._end_col
  )
end

-- Predicates -----------------------------------------------------------------
function H.is_fun_or_string(x, allow_nil)
  allow_nil = allow_nil == nil and true or allow_nil
  return (allow_nil and x == nil) or type(x) == 'function' or type(x) == 'string'
end

function H.is_item(x)
  return type(x) == 'table'
    and H.is_fun_or_string(x['action'], false)
    and type(x['name']) == 'string'
    and type(x['section']) == 'string'
end

function H.is_to_autoopen()
  local listed_buffers = vim.tbl_filter(function(buf_id)
    return vim.fn.buflisted(buf_id) == 1
  end, vim.api.nvim_list_bufs())
  return vim.fn.line2byte '$' > 0 or #listed_buffers > 1 or vim.fn.argc() > 0
end

-- Utilities ------------------------------------------------------------------
function H.eval_fun_or_string(x, string_as_cmd)
  if type(x) == 'function' then
    return x()
  end
  if type(x) == 'string' then
    if string_as_cmd then
      vim.cmd(x)
    else
      return x
    end
  end
end

function H.buf_keymap(key, cmd)
  vim.api.nvim_buf_set_keymap(
    H.buf_id,
    'n',
    key,
    ('<Cmd>lua %s<CR>'):format(cmd),
    { nowait = true, silent = true }
  )
end

function H.buf_hl(ns_id, hl_group, line, col_start, col_end)
  vim.api.nvim_buf_add_highlight(H.buf_id, ns_id, hl_group, line, col_start, col_end)
end

function H.notify(msg)
  vim.notify(('(Starter) %s'):format(msg))
end

function H.unique_nprefix(strings)
  -- Make copy because it will be modified
  local str_set = vim.deepcopy(strings)
  local res, cur_n = {}, 0
  while vim.tbl_count(str_set) > 0 do
    cur_n = cur_n + 1

    -- `prefix_tbl`: string id's with current prefix
    -- `nowhere_to_go` is `true` if all strings have lengths less than `cur_n`
    local prefix_tbl, nowhere_to_go = {}, true
    for id, s in pairs(str_set) do
      nowhere_to_go = nowhere_to_go and (#s < cur_n)
      local prefix = s:sub(1, cur_n)
      prefix_tbl[prefix] = prefix_tbl[prefix] == nil and {} or prefix_tbl[prefix]
      table.insert(prefix_tbl[prefix], id)
    end

    -- Output for non-unique string is its length
    if nowhere_to_go then
      for k, s in pairs(str_set) do
        res[k] = #s
      end
      break
    end

    for _, keys_with_prefix in pairs(prefix_tbl) do
      -- If prefix is seen only once, it is unique
      if #keys_with_prefix == 1 then
        local k = keys_with_prefix[1]
        -- Use `math.min` to account for empty strings and non-unique ones
        res[k] = math.min(#str_set[k], cur_n)
        -- Remove this string as it already has final nprefix
        str_set[k] = nil
      end
    end
  end

  return res
end

return M
