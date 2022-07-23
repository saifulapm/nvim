local fn = vim.fn
local api = vim.api
local fmt = string.format

-- Global Object
_G.G = {}

G.cache = {}

local palette = {
  green = '#98c379',
  dark_green = '#10B981',
  blue = '#82AAFE',
  dark_blue = '#4e88ff',
  bright_blue = '#51afef',
  teal = '#15AABF',
  pale_pink = '#b490c0',
  magenta = '#c678dd',
  pale_red = '#E06C75',
  light_red = '#c43e1f',
  dark_red = '#be5046',
  dark_orange = '#FF922B',
  bright_yellow = '#FAB005',
  light_yellow = '#e5c07b',
  whitesmoke = '#9E9E9E',
  light_gray = '#626262',
  comment_grey = '#5c6370',
  grey = '#3E4556',
}

G.style = {
  icons = {
    separators = {
      vert_bottom_half_block = '▄',
      vert_top_half_block = '▀',
    },
    lsp = {
      error = '✗', -- '✗'
      warn = '',
      info = '', -- 
      hint = '', -- ⚑
    },
    git = {
      add = '', -- '',
      mod = '',
      remove = '', -- '',
      ignore = '',
      rename = '',
      diff = '',
      repo = '',
      logo = '',
      branch = '',
    },
    documents = {
      file = '',
      files = '',
      folder = '',
      open_folder = '',
    },
    type = {
      array = '',
      number = '',
      object = '',
      null = '[]',
      float = '',
    },
    misc = {
      ellipsis = '…',
      up = '⇡',
      down = '⇣',
      line = 'ℓ', -- ''
      indent = 'Ξ',
      tab = '⇥',
      bug = '', -- 'ﴫ'
      question = '',
      clock = '',
      lock = '',
      circle = '',
      project = '',
      dashboard = '',
      history = '',
      comment = '',
      robot = 'ﮧ',
      lightbulb = '',
      search = '',
      code = '',
      telescope = '',
      gear = '',
      package = '',
      list = '',
      sign_in = '',
      check = '',
      fire = '',
      note = '',
      bookmark = '',
      pencil = '',
      tools = '',
      arrow_right = '',
      caret_right = '',
      chevron_right = '',
      double_chevron_right = '»',
      table = '',
      calendar = '',
      block = '▌',
    },
    kinds = {
      codicons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = '',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
        Namespace = '?',
        Package = '?',
        String = '?',
        Number = '?',
        Boolean = '?',
        Array = '?',
        Object = '?',
        Key = '?',
        Null = '?',
      },
      nerdfonts = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '', -- '',
        Variable = '', -- '',
        Class = '', -- '',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '塞',
        Value = '',
        Enum = '',
        Keyword = '', -- '',
        Snippet = '', -- '', '',
        Color = '',
        File = '',
        Reference = '', -- '',
        Folder = '',
        EnumMember = '',
        Constant = '', -- '',
        Struct = '', -- 'פּ',
        Event = '',
        Operator = '',
        TypeParameter = '',
        Namespace = '?',
        Package = '?',
        String = '?',
        Number = '?',
        Boolean = '?',
        Array = '?',
        Object = '?',
        Key = '?',
        Null = '?',
      },
    },
  },
  lsp = {
    colors = {
      error = palette.pale_red,
      warn = palette.dark_orange,
      hint = palette.bright_blue,
      info = palette.teal,
    },
    highlights = {
      Text = 'String',
      Method = 'Method',
      Function = 'Function',
      Constructor = 'TSConstructor',
      Field = 'Field',
      Variable = 'Variable',
      Class = 'Class',
      Interface = 'Constant',
      Module = 'Include',
      Property = 'Property',
      Unit = 'Constant',
      Value = 'Variable',
      Enum = 'Type',
      Keyword = 'Keyword',
      File = 'Directory',
      Reference = 'PreProc',
      Constant = 'Constant',
      Struct = 'Type',
      Snippet = 'Label',
      Event = 'Variable',
      Operator = 'Operator',
      TypeParameter = 'Type',
      Namespace = 'TSNamespace',
      Package = 'Include',
      String = 'String',
      Number = 'Number',
      Boolean = 'Boolean',
      Array = 'StorageClass',
      Object = 'Type',
      Key = 'Field',
      Null = 'ErrorMsg',
      EnumMember = 'Field',
    },
  },
  border = {
    cmp = {
      { '🭽', 'CmpBorder' },
      { '▔', 'CmpBorder' },
      { '🭾', 'CmpBorder' },
      { '▕', 'CmpBorder' },
      { '🭿', 'CmpBorder' },
      { '▁', 'CmpBorder' },
      { '🭼', 'CmpBorder' },
      { '▏', 'CmpBorder' },
    },
    chars = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    line = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
    rectangle = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  },
  palette = palette,
}

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function G.fold(callback, list, accum)
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum, 'The accumulator must be returned on each iteration')
  end
  return accum
end

---@generic T : table
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
function G.map(callback, list)
  return G.fold(function(accum, v, k)
    accum[#accum + 1] = callback(v, k, accum)
    return accum
  end, list, {})
end

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function G.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function G.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == 'string' then
    return item == ''
  elseif item_type == 'number' then
    return item <= 0
  elseif item_type == 'table' then
    return vim.tbl_isempty(item)
  end
  return item ~= nil
end

function _G.P(...)
  local objects, v = {}, nil
  for i = 1, select('#', ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

G.list_installed_plugins = (function()
  local plugins
  return function()
    if plugins then
      return plugins
    end
    local data_dir = fn.stdpath 'data'
    local start = fn.expand(data_dir .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(data_dir .. '/site/pack/packer/opt/*', true, true)
    plugins = vim.list_extend(start, opt)
    return plugins
  end
end)()

---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function G.plugin_installed(plugin_name)
  for _, path in ipairs(G.list_installed_plugins()) do
    if vim.endswith(path, plugin_name) then
      return true
    end
  end
  return false
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function G.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then
      result = opts.message .. '\n' .. result
    end
    vim.notify(result, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
--- TODO: find out if it's possible to annotate the plugin as a module
---@param name string | Plugin
---@param callback fun(module: table)
function G.ftplugin_conf(name, callback)
  local plugin_name = type(name) == 'table' and name.plugin or nil
  if plugin_name and not G.plugin_loaded(plugin_name) then
    return
  end

  local module = type(name) == 'table' and name[1] or name
  local info = debug.getinfo(1, 'S')
  local ok, plugin = G.safe_require(module, { message = fmt('In file: %s', info.source) })

  if ok then
    callback(plugin)
  end
end

---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function G.augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table
function G.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end
