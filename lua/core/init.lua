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
  doom = {
    pale_red = '#E06C75',
    dark_red = '#be5046',
    light_red = '#c43e1f',
    dark_orange = '#FF922B',
    bright_yellow = '#FAB005',
    light_yellow = '#e5c07b',
    comment_grey = '#5c6370',
    grey = '#3E4556',
    whitesmoke = '#626262',
    bright_blue = '#51afef',
    teal = '#15AABF',
    red = '#ff6c6b',
    orange = '#da8548',
    green = '#98be65',
    yellow = '#ECBE7B',
    blue = '#51afef',
    dark_blue = '#2257A0',
    magenta = '#c678dd',
    violet = '#a9a1e1',
    dark_violet = '#4e4f67',
    cyan = '#46D9FF',
    white = '#efefef',
    black = 'Background',
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
    line = {
      { '🭽', 'FloatBorder' },
      { '▔', 'FloatBorder' },
      { '🭾', 'FloatBorder' },
      { '▕', 'FloatBorder' },
      { '🭿', 'FloatBorder' },
      { '▁', 'FloatBorder' },
      { '🭼', 'FloatBorder' },
      { '▏', 'FloatBorder' },
    },
    chars = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
  },
}

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
