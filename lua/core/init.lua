-- Global Object
_G.G = {}

G.cache = {}

G.style = {
  icons = {
    lsp = {
      error = '✗',
      warn = '',
      info = '',
      hint = '',
    },
    git = {
      add = '',
      mod = '',
      remove = '',
      ignore = '',
      rename = '',
      diff = '',
      repo = '',
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
    },
    misc = {
      bug = '',
      question = '',
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
      chevron_right = '',
      table = '',
      calendar = '',
      theme_toggle = '   ',
    },
  },
  kinds = {
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
  ui = {
    theme = 'gruvchad',
  },
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
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    vim.api.nvim_create_autocmd(autocmd.event, {
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
  vim.api.nvim_create_user_command(name, rhs, opts)
end
