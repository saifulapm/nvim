local M = {}
local uv = vim.loop
local config = {
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },

  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},
  silent_chdir = false,
}

function M.globtopattern(g)
  local p = '^' -- pattern being built
  local i = 0 -- index in g
  local c -- char at index i in g.

  -- unescape glob char
  local function unescape()
    if c == '\\' then
      i = i + 1
      c = g:sub(i, i)
      if c == '' then
        p = '[^]'
        return false
      end
    end
    return true
  end

  -- escape pattern char
  local function escape(ch)
    return ch:match '^%w$' and ch or '%' .. ch
  end

  -- Convert tokens at end of charset.
  local function charset_end()
    while 1 do
      if c == '' then
        p = '[^]'
        return false
      elseif c == ']' then
        p = p .. ']'
        break
      else
        if not unescape() then
          break
        end
        local c1 = c
        i = i + 1
        c = g:sub(i, i)
        if c == '' then
          p = '[^]'
          return false
        elseif c == '-' then
          i = i + 1
          c = g:sub(i, i)
          if c == '' then
            p = '[^]'
            return false
          elseif c == ']' then
            p = p .. escape(c1) .. '%-]'
            break
          else
            if not unescape() then
              break
            end
            p = p .. escape(c1) .. '-' .. escape(c)
          end
        elseif c == ']' then
          p = p .. escape(c1) .. ']'
          break
        else
          p = p .. escape(c1)
          i = i - 1 -- put back
        end
      end
      i = i + 1
      c = g:sub(i, i)
    end
    return true
  end

  -- Convert tokens in charset.
  local function charset()
    i = i + 1
    c = g:sub(i, i)
    if c == '' or c == ']' then
      p = '[^]'
      return false
    elseif c == '^' or c == '!' then
      i = i + 1
      c = g:sub(i, i)
      if c == ']' then
        -- ignored
      else
        p = p .. '[^'
        if not charset_end() then
          return false
        end
      end
    else
      p = p .. '['
      if not charset_end() then
        return false
      end
    end
    return true
  end

  -- Convert tokens.
  while 1 do
    i = i + 1
    c = g:sub(i, i)
    if c == '' then
      p = p .. '$'
      break
    elseif c == '?' then
      p = p .. '.'
    elseif c == '*' then
      p = p .. '.*'
    elseif c == '[' then
      if not charset() then
        break
      end
    elseif c == '\\' then
      i = i + 1
      c = g:sub(i, i)
      if c == '' then
        p = p .. '\\$'
        break
      end
      p = p .. escape(c)
    else
      p = p .. escape(c)
    end
  end
  return p
end

function M.set_pwd(dir, method)
  if dir ~= nil then
    vim.cmd [[
      augroup Persistence
        autocmd!
        autocmd VimLeavePre * lua require("utils.session").save()
      augroup end
    ]]

    if vim.fn.getcwd() ~= dir then
      vim.api.nvim_set_current_dir(dir)

      if config.silent_chdir == false then
        vim.notify('Set CWD to ' .. dir .. ' using ' .. method)
      end
    end
    return true
  end

  return false
end

function M.get_project_root()
  local search_dir = vim.fn.expand('%:p:h', true)
  local last_dir_cache = ''
  local curr_dir_cache = {}

  local function get_parent(path)
    path = path:match '^(.*)/'
    if path == '' then
      path = '/'
    end
    return path
  end

  local function get_files(file_dir)
    last_dir_cache = file_dir
    curr_dir_cache = {}

    local dir = uv.fs_scandir(file_dir)
    if dir == nil then
      return
    end

    while true do
      local file = uv.fs_scandir_next(dir)
      if file == nil then
        return
      end

      table.insert(curr_dir_cache, file)
    end
  end

  local function is(dir, identifier)
    dir = dir:match '.*/(.*)'
    return dir == identifier
  end

  local function sub(dir, identifier)
    local path = get_parent(dir)
    while true do
      if is(path, identifier) then
        return true
      end
      local current = path
      path = get_parent(path)
      if current == path then
        return false
      end
    end
  end

  local function child(dir, identifier)
    local path = get_parent(dir)
    return is(path, identifier)
  end

  local function has(dir, identifier)
    if last_dir_cache ~= dir then
      get_files(dir)
    end
    local pattern = M.globtopattern(identifier)
    for _, file in ipairs(curr_dir_cache) do
      if file:match(pattern) ~= nil then
        return true
      end
    end
    return false
  end

  local function match(dir, pattern)
    local first_char = pattern:sub(1, 1)
    if first_char == '=' then
      return is(dir, pattern:sub(2))
    elseif first_char == '^' then
      return sub(dir, pattern:sub(2))
    elseif first_char == '>' then
      return child(dir, pattern:sub(2))
    else
      return has(dir, pattern)
    end
  end

  -- breadth-first search
  while true do
    for _, pattern in ipairs(config.patterns) do
      local exclude = false
      if pattern:sub(1, 1) == '!' then
        exclude = true
        pattern = pattern:sub(2)
      end
      if match(search_dir, pattern) then
        if exclude then
          break
        else
          return search_dir, 'pattern ' .. pattern
        end
      end
    end

    local parent = get_parent(search_dir)
    if parent == search_dir or parent == nil then
      return nil
    end

    search_dir = parent
  end
end

function M.is_file()
  local buf_type = vim.api.nvim_buf_get_option(0, 'buftype')

  local whitelisted_buf_type = { '', 'acwrite' }
  local is_in_whitelist = false
  for _, wtype in ipairs(whitelisted_buf_type) do
    if buf_type == wtype then
      is_in_whitelist = true
      break
    end
  end
  if not is_in_whitelist then
    return false
  end

  return true
end

function M.is_excluded(dir)
  local home = vim.fn.expand '~'
  local exclude_dirs = vim.tbl_map(function(pattern)
    if vim.startswith(pattern, '~/') then
      pattern = home .. '/' .. pattern:sub(3, #pattern)
    end
    return M.globtopattern(pattern)
  end, config.exclude_dirs)

  for _, dir_pattern in ipairs(exclude_dirs) do
    if dir:match(dir_pattern) ~= nil then
      return true
    end
  end

  return false
end

function M.on_buf_enter()
  if vim.v.vim_did_enter == 0 then
    return
  end

  if not M.is_file() then
    return
  end

  local current_dir = vim.fn.expand('%:p:h', true)
  if M.is_excluded(current_dir) then
    return
  end

  local root, method = M.get_project_root()
  M.set_pwd(root, method)
end

return M
