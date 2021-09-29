local M = {}

M.close_buffer = function(_, force)
  -- This is a modification of a NeoVim plugin from
  -- Author: ojroques - Olivier Roques
  -- Src: https://github.com/ojroques/nvim-bufdel
  -- (Author has okayed copy-paste)

  -- Options
  local opts = {
    next = 'cycle', -- how to retrieve the next buffer
    quit = false, -- exit when last buffer is deleted
    --TODO make this a chadrc flag/option
  }

  -- ----------------
  -- Helper functions
  -- ----------------

  -- Switch to buffer 'buf' on each window from list 'windows'
  local function switch_buffer(windows, buf)
    local cur_win = vim.fn.winnr()
    for _, winid in ipairs(windows) do
      vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
      vim.cmd(string.format('buffer %d', buf))
    end
    vim.cmd(string.format('%d wincmd w', cur_win)) -- return to original window
  end

  -- Select the first buffer with a number greater than given buffer
  local function get_next_buf(buf)
    local next = vim.fn.bufnr '#'
    if opts.next == 'alternate' and vim.fn.buflisted(next) == 1 then
      return next
    end
    for i = 0, vim.fn.bufnr '$' - 1 do
      next = (buf + i) % vim.fn.bufnr '$' + 1 -- will loop back to 1
      if vim.fn.buflisted(next) == 1 then
        return next
      end
    end
  end

  -- ----------------
  -- End helper functions
  -- ----------------

  local buf = vim.fn.bufnr()
  if vim.fn.buflisted(buf) == 0 then -- exit if buffer number is invalid
    vim.cmd 'close'
    return
  end

  if #vim.fn.getbufinfo { buflisted = 1 } < 2 then
    if opts.quit then
      -- exit when there is only one buffer left
      if force then
        vim.cmd 'qall!'
      else
        vim.cmd 'confirm qall'
      end
      return
    end

    local chad_term, type = pcall(function()
      return vim.api.nvim_buf_get_var(buf, 'term_type')
    end)

    if chad_term then
      -- Must be a window type
      vim.cmd(string.format('setlocal nobl', buf))
      vim.cmd 'enew'
      return
    end
    -- don't exit and create a new empty buffer
    vim.cmd 'enew'
    vim.cmd 'bp'
  end

  local next_buf = get_next_buf(buf)
  local windows = vim.fn.getbufinfo(buf)[1].windows

  -- force deletion of terminal buffers to avoid the prompt
  if force or vim.fn.getbufvar(buf, '&buftype') == 'terminal' then
    local chad_term, type = pcall(function()
      return vim.api.nvim_buf_get_var(buf, 'term_type')
    end)

    -- TODO this scope is error prone, make resilient
    if chad_term then
      if type == 'wind' then
        -- hide from bufferline
        vim.cmd(string.format('%d bufdo setlocal nobl', buf))
        -- swtich to another buff
        -- TODO switch to next bufffer, this works too
        vim.cmd 'BufferLineCycleNext'
      else
        local cur_win = vim.fn.winnr()
        -- we can close this window
        vim.cmd(string.format('%d wincmd c', cur_win))
        return
      end
    else
      switch_buffer(windows, next_buf)
      vim.cmd(string.format('bd! %d', buf))
    end
  else
    switch_buffer(windows, next_buf)
    vim.cmd(string.format('silent! confirm bd %d', buf))
  end
  -- revert buffer switches if user has canceled deletion
  if vim.fn.buflisted(buf) == 1 then
    switch_buffer(windows, buf)
  end
end

-- load config
-- 1st arg = boolean - whether to force reload
-- Modifies _G._NVCHAD_CONFIG global variable
M.load_config = function(reload)
  if _G._MAIN_CONFIG ~= nil and not (reload or false) then
    return _G._MAIN_CONFIG
  end

  local main_config = 'config'

  -- unload the modules if force reload
  if reload then
    package.loaded[main_config or false] = nil
  end

  _G._MAIN_CONFIG = require(main_config)
  return _G._MAIN_CONFIG
end

M.map = function(mode, keys, cmd, opt)
  local options = { noremap = true, silent = true }
  local buffer = nil

  if opt then
    buffer = opt.buffer
    opt.buffer = nil
    options = vim.tbl_extend('force', options, opt)
  end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [''] = true,
    ['n'] = true,
    ['v'] = true,
    ['s'] = true,
    ['x'] = true,
    ['o'] = true,
    ['!'] = true,
    ['i'] = true,
    ['l'] = true,
    ['c'] = true,
    ['t'] = true,
  }

  -- helper function for M.map
  -- can gives multiple modes and keys
  local function map_wrapper(mo, lhs, rhs, op)
    if type(lhs) == 'table' then
      for _, key in ipairs(lhs) do
        map_wrapper(mo, key, rhs, op)
      end
    else
      if type(mo) == 'table' then
        for _, m in ipairs(mo) do
          map_wrapper(m, lhs, rhs, op)
        end
      else
        if type(rhs) == 'function' then
          local fn_id = gl._create(rhs)
          rhs = string.format('<cmd>lua gl._execute(%s)<CR>', fn_id)
        end
        if valid_modes[mo] and lhs and rhs then
          if buffer and type(buffer) == 'number' then
            return vim.api.nvim_buf_set_keymap(buffer, mo, lhs, rhs, op)
          end
          vim.api.nvim_set_keymap(mo, lhs, rhs, op)
        else
          mo, lhs, rhs = mo or '', lhs or '', rhs or ''
          print(
            "Cannot set mapping [ mode = '"
              .. mo
              .. "' | key = '"
              .. lhs
              .. "' | cmd = '"
              .. rhs
              .. "' ]"
          )
        end
      end
    end
  end

  map_wrapper(mode, keys, cmd, options)
end

M.load_packer = function()
  local present, packer = pcall(require, 'packer')

  if not present then
    local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

    print 'Cloning packer..'
    -- remove the dir before cloning
    vim.fn.delete(packer_path, 'rf')
    vim.fn.system {
      'git',
      'clone',
      'https://github.com/wbthomason/packer.nvim',
      '--depth',
      '20',
      packer_path,
    }

    vim.cmd 'packadd packer.nvim'

    present, packer = pcall(require, 'packer')

    if present then
      print 'Packer cloned successfully.'
    else
      error("Couldn't clone packer !\nPacker path: " .. packer_path .. '\n' .. packer)
    end
  else
    vim.cmd 'packadd packer.nvim'
  end

  -- HACK: see https://github.com/wbthomason/packer.nvim/issues/180
  vim.fn.setenv('MACOSX_DEPLOYMENT_TARGET', '10.15')

  packer.init {
    max_jobs = 20,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 600, -- Timeout, in seconds, for git clones
    },
    auto_clean = true,
    compile_on_sync = true,
  }
  return packer
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require('packer').loader(plugin)
    end, timer)
  end
end

---Install an executable, returning the error if any
---@param binary string
---@param installer string
---@param cmd string
---@return string?
M.install = function(binary, installer, cmd, opts)
  opts = opts or { silent = true }
  cmd = cmd or 'install'
  if not gl.executable(binary) and gl.executable(installer) then
    local install_cmd = string.format('%s %s %s', installer, cmd, binary)
    if opts.silent then
      vim.cmd('!' .. install_cmd)
    else
      -- open a small split, make it full width, run the command
      vim.cmd(string.format('25split | wincmd J | terminal %s', install_cmd))
    end
  end
end

-- Edit user config file, based on the assumption it exists in the config as
-- theme = "theme name"
-- 1st arg as current theme, 2nd as new theme
M.change_theme = function(current_theme, new_theme)
  if current_theme == nil or new_theme == nil then
    print 'Error: Provide current and new theme name'
    return false
  end
  if current_theme == new_theme then
    return
  end

  local file_fn = require('utils').file
  local file = vim.fn.stdpath 'config' .. '/lua/config.lua'
  -- store in data variable
  local data = assert(file_fn('r', file))
  -- escape characters which can be parsed as magic chars
  current_theme = current_theme:gsub('%p', '%%%0')
  new_theme = new_theme:gsub('%p', '%%%0')
  local find = 'theme = .?' .. current_theme .. '.?'
  local replace = 'theme = "' .. new_theme .. '"'
  local content = string.gsub(data, find, replace)
  -- see if the find string exists in file
  if content == data then
    print(
      'Error: Cannot change default theme with ' .. new_theme .. ', edit ' .. file .. ' manually'
    )
    return false
  else
    assert(file_fn('w', file, content))
  end
end

-- clear command line from lua
M.clear_cmdline = function()
  vim.defer_fn(function()
    vim.cmd 'echo'
  end, 0)
end

-- wrapper to use vim.api.nvim_echo
-- table of {string, highlight}
-- e.g echo({{"Hello", "Title"}, {"World"}})
M.echo = function(opts)
  if opts == nil or type(opts) ~= 'table' then
    return
  end
  vim.api.nvim_echo(opts, false, {})
end

-- 1st arg - r or w
-- 2nd arg - file path
-- 3rd arg - content if 1st arg is w
-- return file data on read, nothing on write
M.file = function(mode, filepath, content)
  local data
  local fd = assert(vim.loop.fs_open(filepath, mode, 438))
  local stat = assert(vim.loop.fs_fstat(fd))
  if stat.type ~= 'file' then
    data = false
  else
    if mode == 'r' then
      data = assert(vim.loop.fs_read(fd, stat.size, 0))
    else
      assert(vim.loop.fs_write(fd, content, 0))
      data = true
    end
  end
  assert(vim.loop.fs_close(fd))
  return data
end

-- reload a plugin ( will try to load even if not loaded)
-- can take a string or list ( table )
-- return true or false
M.reload_plugin = function(plugins)
  local status = true
  local function _reload_plugin(plugin)
    local loaded = package.loaded[plugin]
    if loaded then
      package.loaded[plugin] = nil
    end
    local ok, err = pcall(require, plugin)
    if not ok then
      print('Error: Cannot load ' .. plugin .. ' plugin!\n' .. err .. '\n')
      status = false
    end
  end

  if type(plugins) == 'string' then
    _reload_plugin(plugins)
  elseif type(plugins) == 'table' then
    for _, plugin in ipairs(plugins) do
      _reload_plugin(plugin)
    end
  end
  return status
end

-- reload themes without restarting vim
-- if no theme name given then reload the current theme
M.reload_theme = function(theme_name)
  local reload_plugin = require('utils').reload_plugin

  -- if theme name is empty or nil, then reload the current theme
  if theme_name == nil or theme_name == '' then
    theme_name = vim.g.main_theme
  end

  if not pcall(require, 'hl_themes.' .. theme_name) then
    print('No such theme ( ' .. theme_name .. ' )')
    return false
  end

  vim.g.main_theme = theme_name

  -- reload the base16 theme and highlights
  require('theme').init(theme_name)

  if
    not reload_plugin {
      'plugins.configs.bufferline',
      'plugins.configs.statusline',
    }
  then
    print 'Error: Not able to reload all plugins.'
    return false
  end

  return true
end

-- toggle between 2 themes
-- argument should be a table with 2 theme names
M.toggle_theme = function(themes)
  local current_theme = vim.g.current_main_theme or vim.g.main_theme
  for _, name in ipairs(themes) do
    if name ~= current_theme then
      if require('utils').reload_theme(name) then
        -- open a buffer and close it to reload the statusline
        vim.cmd 'new|bwipeout'
        vim.g.current_main_theme = name
        if require('utils').change_theme(vim.g.main_theme, name) then
          vim.g.main_theme = name
        end
      end
    end
  end
end

-- return a table of available themes
M.list_themes = function(return_type)
  local themes = {}
  -- folder where theme files are stored
  local themes_folder = vim.fn.stdpath 'data'
    .. '/site/pack/packer/opt/nvim-base16.lua/lua/hl_themes'
  -- list all the contents of the folder and filter out files with .lua extension, then append to themes table
  local fd = vim.loop.fs_scandir(themes_folder)
  if fd then
    while true do
      local name, typ = vim.loop.fs_scandir_next(fd)
      if name == nil then
        break
      end
      if typ ~= 'directory' and string.find(name, '.lua$') then
        -- return the table values as keys if specified
        if return_type == 'keys_as_value' then
          themes[vim.fn.fnamemodify(name, ':r')] = true
        else
          table.insert(themes, vim.fn.fnamemodify(name, ':r'))
        end
      end
    end
  end
  return themes
end

M.theme_switcher = function(opts)
  if not gl.plugin_loaded 'telescope' then
    vim.cmd [[packadd telescope.nvim]]
  end
  local pickers, finders, previewers, actions, action_state, utils, conf
  if pcall(require, 'telescope') then
    pickers = require 'telescope.pickers'
    finders = require 'telescope.finders'
    previewers = require 'telescope.previewers'

    actions = require 'telescope.actions'
    action_state = require 'telescope.actions.state'
    utils = require 'telescope.utils'
    conf = require('telescope.config').values
  else
    error 'Cannot find telescope!'
  end

  local local_utils = require 'utils'
  local reload_theme = local_utils.reload_theme

  -- get a table of available themes
  local themes = local_utils.list_themes()
  if next(themes) ~= nil then
    -- save this to use it for later to restore if theme not changed
    local current_theme = vim.g.main_theme
    local new_theme = ''
    local change = false

    -- buffer number and name
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    local previewer

    -- in case its not a normal buffer
    if vim.fn.buflisted(bufnr) ~= 1 then
      local deleted = false
      local function del_win(win_id)
        if win_id and vim.api.nvim_win_is_valid(win_id) then
          utils.buf_delete(vim.api.nvim_win_get_buf(win_id))
          pcall(vim.api.nvim_win_close, win_id, true)
        end
      end

      previewer = previewers.new {
        preview_fn = function(_, entry, status)
          if not deleted then
            deleted = true
            del_win(status.preview_win)
            del_win(status.preview_border_win)
          end
          reload_theme(entry.value)
        end,
      }
    else
      -- show current buffer content in previewer
      previewer = previewers.new_buffer_previewer {
        get_buffer_by_name = function()
          return bufname
        end,
        define_preview = function(self, entry)
          if vim.loop.fs_stat(bufname) then
            conf.buffer_previewer_maker(bufname, self.state.bufnr, {
              bufname = self.state.bufname,
            })
          else
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          end
          reload_theme(entry.value)
        end,
      }
    end

    local picker = pickers.new {
      prompt_title = 'Set Nvim color',
      finder = finders.new_table(themes),
      previewer = previewer,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(
          -- if a entry is selected, change current_theme to that
          function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            new_theme = selection.value
            change = true
            actions.close(prompt_bufnr)
          end
        )
        return true
      end,
    }

    -- rewrite picker.close_windows
    local close_windows = picker.close_windows
    picker.close_windows = function(status)
      close_windows(status)
      -- now apply the theme, if success, then ask for default theme change
      local final_theme
      if change then
        final_theme = new_theme
      else
        final_theme = current_theme
      end

      if reload_theme(final_theme) then
        if change then
          -- ask for confirmation to set as default theme
          local ans = string.lower(
            vim.fn.input('Set ' .. new_theme .. ' as default theme ? [y/N] ')
          ) == 'y'
          local_utils.clear_cmdline()
          if ans then
            local_utils.change_theme(current_theme, final_theme)
          else
            -- will be used in restoring nvchad theme var
            final_theme = current_theme
          end
        end
      else
        final_theme = current_theme
      end
      -- set nvchad_theme global var
      vim.g.nvchad_theme = final_theme
    end
    -- launch the telescope picker
    picker:find()
  else
    print('No themes found in ' .. vim.fn.stdpath 'config' .. '/lua/themes')
  end
end

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

return M
