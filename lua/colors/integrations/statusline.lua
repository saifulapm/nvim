local colors = require('colors').load()
local utils = require 'utils.colors'

local indicator_color = colors.bright_blue
local warning_fg = colors.dark_orange

local error_color = colors.pale_red
local info_color = colors.teal
local normal_fg = colors.fg
local string_fg = colors.green
local number_fg = G.style.ui.light_bg and colors.yellow or colors.orange

local normal_bg = G.style.ui.transparent and 'NONE' or colors.bg
local dim_color = utils.Lighten(normal_bg, 0.4)
local bg_color = utils.Darken(normal_bg, 0.16)

return {
  StMetadata = { background = bg_color, foreground = colors.fg_alt },
  StMetadataPrefix = { background = bg_color, foreground = colors.fg_alt },
  StIndicator = { background = bg_color, foreground = indicator_color },
  StModified = { foreground = string_fg, background = bg_color },
  StGit = { foreground = P.light_gray, background = bg_color },
  StGreen = { foreground = string_fg, background = bg_color },
  StBlue = { foreground = P.dark_blue, background = bg_color, bold = true },
  StNumber = { foreground = number_fg, background = bg_color },
  StCount = { foreground = 'bg', background = indicator_color, bold = true },
  StClient = { background = bg_color, foreground = normal_fg, bold = true },
  StDirectory = { background = bg_color, foreground = 'Gray', italic = true },
  StDirectoryInactive = { background = bg_color, foreground = dim_color, italic = true },
  StParentDirectory = { background = bg_color, foreground = string_fg, bold = true },
  StTitle = { background = bg_color, foreground = 'LightGray', bold = true },
  StComment = { background = bg_color, foreground = colors.fg_alt },
  StatusLine = { background = bg_color },
  StatusLineNC = { link = 'VertSplit' },
  StInfo = { foreground = info_color, background = bg_color, bold = true },
  StWarn = { foreground = warning_fg, background = bg_color },
  StError = { foreground = error_color, background = bg_color },
  StFilename = { background = bg_color, foreground = 'LightGray', bold = true },
  StFilenameInactive = { foreground = colors.fg_alt, background = bg_color, bold = true },
  StModeNormal = { background = bg_color, foreground = P.light_gray, bold = true },
  StModeInsert = { background = bg_color, foreground = P.dark_blue, bold = true },
  StModeVisual = { background = bg_color, foreground = P.magenta, bold = true },
  StModeReplace = { background = bg_color, foreground = P.dark_red, bold = true },
  StModeCommand = { background = bg_color, foreground = P.light_yellow, bold = true },
  StModeSelect = { background = bg_color, foreground = P.teal, bold = true },
  -- FOR HYDRA
  HydraRedSt = { link = 'HydraRed', reverse = true },
  HydraBlueSt = { link = 'HydraBlue', reverse = true },
  HydraAmaranthSt = { link = 'HydraAmaranth', reverse = true },
  HydraTealSt = { link = 'HydraTeal', reverse = true },
  HydraPinkSt = { link = 'HydraPink', reverse = true },
}
