local M = {}
local api = vim.api
local option = api.nvim_buf_get_option

-- Toggle (,) and (;) easily
M.toggle_char = function(char)
  local fn = vim.fn
  local line = fn.getline '.'
  local newline = ''

  if char == string.sub(line, #line) then
    newline = line:sub(1, -2)
  else
    newline = line .. char
  end

  return fn.setline('.', newline)
end

local get_map_options = function(custom_options)
  local options = { silent = true, noremap = true }
  if custom_options then
    options = vim.tbl_extend('force', options, custom_options)
  end
  return options
end

M.map = function(mode, keys, cmd, opts)
  vim.keymap.set(mode, keys, cmd, get_map_options(opts))
end

-- load plugin after entering vim ui
M.lazy = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require('packer').loader(plugin)
    end, timer)
  end
end

M.scratch = function(win)
  api.nvim_win_set_buf(win or 0, api.nvim_create_buf(false, true))
end

local function notify(msg)
  vim.notify('Buffers: ' .. msg)
end

M.buf_only = function()
  local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

  local cur = api.nvim_get_current_buf()

  local deleted, modified = 0, 0

  for _, n in ipairs(api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    if option(n, 'modified') then
      modified = modified + 1

      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
    elseif n ~= cur and (option(n, 'modifiable') or del_non_modifiable) then
      api.nvim_buf_delete(n, {})
      deleted = deleted + 1
    end
  end

  notify('Buffers: ' .. ('%s deleted, %s modified'):format(deleted, modified))
end

---Remove all the buffers
---@param opts table
function M.clear(opts)
  opts = opts or {}

  local deleted, modified = 0, 0
  for _, buf in ipairs(api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    if option(buf, 'modified') then
      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      modified = modified + 1
    elseif (option(buf, 'modifiable') or opts.non_modifiable) and option(buf, 'buflisted') then
      api.nvim_buf_delete(buf, { force = true })
      deleted = deleted + 1
    end
  end

  -- If current buffer is not scratch then and only create scratch buffer
  local cur_buf = api.nvim_get_current_buf()
  if option(cur_buf, 'buflisted') then
    M.scratch()
    api.nvim_buf_delete(cur_buf, { force = true })
  end

  notify('Buffers: ' .. ('%s deleted, %s modified'):format(deleted, modified))
end

M.visual_macro = function()
  vim.cmd [[execute ":'<,'>normal @".nr2char(getchar())]]
end

M.gfind = function(str, substr, cb, init)
  init = init or 1
  local start_pos, end_pos = str:find(substr, init)
  if start_pos then
    cb(start_pos, end_pos)
    return M.gfind(str, substr, cb, end_pos + 1)
  end
end

M.input = function(keys, mode)
  api.nvim_feedkeys(M.t(keys), mode or 'm', true)
end

M.warn = function(msg)
  api.nvim_echo({ { msg, 'WarningMsg' } }, true, {})
end

M.table = {
  some = function(tbl, cb)
    for k, v in pairs(tbl) do
      if cb(k, v) then
        return true
      end
    end
    return false
  end,
}

return M
