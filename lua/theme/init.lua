local levels = vim.log.levels
local M = {}

---Convert a hex color to RGB
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent)
  return math.floor(attr * (100 + percent) / 100)
end

local function get_hl(group_name)
  local attrs = { foreground = 'guifg', background = 'guibg' }
  local hl = vim.api.nvim_get_hl_by_name(group_name, true)
  local result = {}
  if hl then
    local gui = {}
    for key, value in pairs(hl) do
      local t = type(value)
      if t == 'number' and attrs[key] then
        result[attrs[key]] = '#' .. bit.tohex(value, 6)
      elseif t == 'boolean' then -- NOTE: we presume that a boolean value is a GUI attribute
        table.insert(gui, key)
      end
    end
    result.gui = #gui > 0 and gui or nil
  end
  return result
end

-- if theme given, load given theme if given, otherwise nvchad_theme
M.init = function(theme)
  if not theme then
    theme = require('utils').load_config().ui.theme
  end

  -- set the global theme, used at various places like theme switcher, highlights
  vim.g.main_theme = theme

  local present, base16 = pcall(require, 'base16')

  if present then
    -- first load the base16 theme
    base16(base16.themes(theme), true)

    -- unload to force reload
    package.loaded['theme.highlights' or false] = nil
    -- then load the highlights
    require 'theme.highlights'
  else
    return false
  end
end

-- returns a table of colors for givem or current theme
M.get = function(theme)
  if not theme then
    theme = vim.g.main_theme
  end
  return require('hl_themes.' .. theme)
end

---@source https://stackoverflow.com/q/5560248
---@see: https://stackoverflow.com/a/37797380
---Darken a specified hex color
---@param color string
---@param percent number
---@return string
M.alter_color = function(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then
    return 'NONE'
  end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return string.format('#%02x%02x%02x', r, g, b)
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---in the right format
---@param grp string
---@param attr string
---@param fallback string
---@return string
M.get_hl = function(grp, attr, fallback)
  if not grp then
    vim.notify('Cannot get a highlight without specifying a group', levels.ERROR)
    return 'NONE'
  end
  local hl = get_hl(grp)
  local color = hl[attr:match 'gui' and attr or string.format('gui%s', attr)] or fallback
  if not color then
    vim.notify(string.format('%s %s does not exist', grp, attr), levels.INFO)
    return 'NONE'
  end
  -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
  return color
end

return M
