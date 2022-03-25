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
