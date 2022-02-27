local M = {}
local defaults = {
  dir = vim.fn.expand(vim.fn.stdpath 'data' .. '/sessions/'), -- directory where session files are saved
  options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- sessionoptions used for saving
}

local e = vim.fn.fnameescape

function M.get_current()
  local pattern = '/'
  if vim.fn.has 'win32' == 1 then
    pattern = '[\\:]'
  end
  local name = vim.fn.getcwd():gsub(pattern, '%%')
  return defaults.dir .. name .. '.vim'
end

function M.get_last()
  local sessions = M.list()
  table.sort(sessions, function(a, b)
    return vim.loop.fs_stat(a).mtime.sec > vim.loop.fs_stat(b).mtime.sec
  end)
  return sessions[1]
end

function M.save()
  local exist = vim.loop.fs_stat(defaults.dir)
  if not exist then
    vim.fn.mkdir(defaults.dir, 'p')
  end
  local tmp = vim.o.sessionoptions
  vim.o.sessionoptions = table.concat(defaults.options, ',')
  vim.cmd('mks! ' .. e(M.get_current()))
  vim.o.sessionoptions = tmp
end

function M.load(file)
  local sfile = file and defaults.dir .. file or M.get_current()
  if sfile and vim.fn.filereadable(sfile) ~= 0 then
    vim.cmd('source ' .. e(sfile))
  end
end

function M.list()
  local globs = vim.fn.glob(defaults.dir .. '*.vim')
  if #globs == 0 then
    return {}
  end

  local res = {}
  for _, f in pairs(vim.split(globs, '\n')) do
    if vim.fn.filereadable(f) ~= 0 then
      local s = {
        modify_time = vim.fn.getftime(defaults.dir),
        name = vim.fn.fnamemodify(f, ':t'),
        path = vim.fn.resolve(vim.fn.fnamemodify(defaults.dir, ':p')),
        type = 'local',
      }
      res[s.name] = s
    end
  end
  return res
end

return M
