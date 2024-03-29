local H = require 'core.highlights'
local utils = require 'utils.statusline'

local api = vim.api
local icons = G.style.icons
local P = G.style.palette
local C = utils.constants

local M = {}

local function colors()
  --- NOTE: Unicode characters including vim devicons should NOT be highlighted
  --- as italic or bold, this is because the underlying bold font is not necessarily
  --- patched with the nerd font characters
  --- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  --- but this is not universal across terminals so should be avoided

  local indicator_color = P.bright_blue
  local warning_fg = G.style.lsp.colors.warn

  local error_color = G.style.lsp.colors.error
  local info_color = G.style.lsp.colors.info
  local normal_fg = H.get('Normal', 'fg')
  local string_fg = H.get('String', 'fg')
  local number_fg = H.get('Number', 'fg')

  local normal_bg = H.get('Normal', 'bg')
  local dim_color = H.alter_color(normal_bg, 40)
  local bg_color = H.alter_color(normal_bg, -16)

  H.all {
    StMetadata = { background = bg_color, inherit = 'Comment' },
    StMetadataPrefix = { background = bg_color, foreground = { from = 'Comment' } },
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
    StComment = { background = bg_color, inherit = 'Comment' },
    StatusLine = { background = bg_color },
    StatusLineNC = { link = 'VertSplit' },
    StInfo = { foreground = info_color, background = bg_color, bold = true },
    StWarn = { foreground = warning_fg, background = bg_color },
    StError = { foreground = error_color, background = bg_color },
    StFilename = { background = bg_color, foreground = 'LightGray', bold = true },
    StFilenameInactive = { inherit = 'Comment', background = bg_color, bold = true },
    StModeNormal = { background = bg_color, foreground = P.light_gray, bold = true },
    StModeInsert = { background = bg_color, foreground = P.dark_blue, bold = true },
    StModeVisual = { background = bg_color, foreground = P.magenta, bold = true },
    StModeReplace = { background = bg_color, foreground = P.dark_red, bold = true },
    StModeCommand = { background = bg_color, foreground = P.light_yellow, bold = true },
    StModeSelect = { background = bg_color, foreground = P.teal, bold = true },
    -- FOR HYDRA
    HydraRedSt = { inherit = 'HydraRed', reverse = true },
    HydraBlueSt = { inherit = 'HydraBlue', reverse = true },
    HydraAmaranthSt = { inherit = 'HydraAmaranth', reverse = true },
    HydraTealSt = { inherit = 'HydraTeal', reverse = true },
    HydraPinkSt = { inherit = 'HydraPink', reverse = true },
  }
end

local separator = function()
  return { component = C.ALIGN, length = 0, priority = 0 }
end
local end_marker = function()
  return { component = C.END, length = 0, priority = 0 }
end

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function G.style.statusline()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)

  local component = utils.component
  local component_if = utils.component_if

  local available_space = vim.opt.columns:get()

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = api.nvim_buf_get_name(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab,
  }
  ----------------------------------------------------------------------------//
  -- Modifiers
  ----------------------------------------------------------------------------//
  local plain = utils.is_plain(ctx)
  local file_modified = utils.modified(ctx, icons.misc.circle)
  local focused = vim.g.vim_in_focus or true
  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {
    component_if(icons.misc.block, not plain, 'StIndicator', {
      before = '',
      after = '',
      priority = 0,
    }),
    utils.spacer(1),
  }
  local add = utils.winline(statusline)
  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local segments = utils.file(ctx, plain)
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local dir_component = component(dir.item, dir.hl, dir.opts)
  local parent_component = component(parent.item, parent.hl, parent.opts)

  if not plain and utils.is_repo(ctx) then
    file.opts.suffix = icons.git.repo
    file.opts.suffix_color = 'StMetadata'
  end
  local file_component = component(file.item, file.hl, file.opts)

  local readonly_component = component(utils.readonly(ctx), 'StIndicator', { priority = 1 })
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if plain or not focused then
    add(readonly_component, dir_component, parent_component, file_component)
    return utils.display(statusline, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//

  local mode, mode_hl = utils.mode()
  local lnum, col = unpack(api.nvim_win_get_cursor(curwin))
  local line_count = api.nvim_buf_line_count(ctx.bufnum)

  -- Git state
  local status = vim.b.gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -- LSP Diagnostics
  local diagnostics = utils.diagnostic_info(ctx)
  local flutter = vim.g.flutter_tools_decorations or {}

  -- HYDRA
  local hydra_active, hydra = utils.hydra()
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    component_if(file_modified, ctx.modified, 'StModified', { priority = 1 }),

    readonly_component,

    component(mode, mode_hl, { priority = 0 }),

    component_if(utils.search_count(), vim.v.hlsearch > 0, 'StCount', { priority = 1 }),

    dir_component,
    parent_component,
    file_component,

    component_if('Saving…', vim.g.is_saving, 'StComment', { before = ' ', priority = 1 }),

    -- Local plugin dev indicator
    component_if(available_space > 100 and 'local dev' or '', vim.env.DEVELOPING ~= nil, 'StComment', {
      prefix = icons.misc.tools,
      padding = 'none',
      before = '  ',
      prefix_color = 'StWarn',
      small = 1,
      priority = 2,
    }),
    separator(),
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//
    -- Neovim allows unlimited alignment sections so we can put things in the
    -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
    -----------------------------------------------------------------------------//
    component_if(hydra.name:upper(), hydra_active, hydra.color, {
      prefix = string.rep(' ', 5) .. '🐙',
      suffix = string.rep(' ', 5),
      priority = 5,
    }),

    -- Start of the right side layout
    separator(),
    -----------------------------------------------------------------------------//
    -- Right section
    -----------------------------------------------------------------------------//
    component(flutter.app_version, 'StMetadata', { priority = 4 }),

    component(flutter.device and flutter.device.name or '', 'StMetadata', { priority = 4 })
  )

  -----------------------------------------------------------------------------//
  -- LSP Clients
  -----------------------------------------------------------------------------//
  local lsp_clients = G.map(function(client, index)
    return component(client.name, 'StClient', {
      prefix = index == 1 and ' LSP(s):' or nil,
      prefix_color = index == 1 and 'StMetadata' or nil,
      suffix = '', -- │
      suffix_color = 'StMetadataPrefix',
      priority = client.priority,
    })
  end, utils.lsp_clients(ctx))
  add(unpack(lsp_clients))
  -----------------------------------------------------------------------------//

  add(
    component(utils.debugger(), 'StMetadata', { prefix = icons.misc.bug, priority = 4 }),

    component_if(diagnostics.error.count, diagnostics.error, 'StError', {
      prefix = diagnostics.error.icon,
      prefix_color = 'StError',
      priority = 1,
    }),

    component_if(diagnostics.warn.count, diagnostics.warn, 'StWarn', {
      prefix = diagnostics.warn.icon,
      prefix_color = 'StWarn',
      priority = 3,
    }),

    component_if(diagnostics.info.count, diagnostics.info, 'StInfo', {
      prefix = diagnostics.info.icon,
      prefix_color = 'StInfo',
      priority = 4,
    }),

    -- Git Status
    component(status.head, 'StBlue', {
      prefix = icons.git.branch,
      prefix_color = 'StGit',
      priority = 1,
    }),

    component(status.changed, 'StTitle', {
      prefix = icons.git.mod,
      prefix_color = 'StWarn',
      priority = 3,
    }),

    component(status.removed, 'StTitle', {
      prefix = icons.git.remove,
      prefix_color = 'StError',
      priority = 3,
    }),

    component(status.added, 'StTitle', {
      prefix = icons.git.add,
      prefix_color = 'StGreen',
      priority = 3,
    }),

    component(ahead, 'StTitle', {
      prefix = icons.misc.up,
      prefix_color = 'StGreen',
      before = '',
      priority = 5,
    }),

    component(behind, 'StTitle', {
      prefix = icons.misc.down,
      prefix_color = 'StNumber',
      after = ' ',
      priority = 5,
    }),

    -- Current line number/total line number
    component(lnum, 'StTitle', {
      after = '',
      prefix = icons.misc.line,
      prefix_color = 'StMetadataPrefix',
      priority = 7,
    }),

    component(line_count, 'StComment', {
      before = '',
      prefix = '/',
      padding = { prefix = false, suffix = true },
      prefix_color = 'StComment',
      priority = 7,
    }),

    -- column
    component(col, 'StTitle', {
      prefix = 'Col:',
      prefix_color = 'StMetadataPrefix',
      priority = 7,
    }),
    -- (Unexpected) Indentation
    component_if(ctx.shiftwidth, ctx.shiftwidth > 2 or not ctx.expandtab, 'StTitle', {
      prefix = ctx.expandtab and icons.misc.indent or icons.misc.tab,
      prefix_color = 'StatusLine',
      priority = 6,
    }),
    end_marker()
  )
  -- removes 5 columns to add some padding
  return utils.display(statusline, available_space - 5)
end

G.augroup('CustomStatusline', {
  {
    event = { 'FocusGained' },
    pattern = { '*' },
    command = function()
      vim.g.vim_in_focus = true
    end,
  },
  {
    event = { 'FocusLost' },
    pattern = { '*' },
    command = function()
      vim.g.vim_in_focus = false
    end,
  },
  {
    event = { 'VimEnter', 'ColorScheme' },
    pattern = { '*' },
    command = colors,
  },
  {
    event = { 'BufReadPre' },
    once = true,
    pattern = { '*' },
    command = utils.git_updates,
  },
  {
    event = { 'BufWritePre' },
    pattern = { '*' },
    command = function()
      if not vim.g.is_saving and vim.bo.modified then
        vim.g.is_saving = true
        vim.defer_fn(function()
          vim.g.is_saving = false
        end, 1000)
      end
    end,
  },
  {
    event = { 'User' },
    pattern = {
      'NeogitPushComplete',
      'NeogitCommitComplete',
      'NeogitStatusRefresh',
    },
    command = function()
      utils.git_updates_refresh()
    end,
  },
})

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%{%v:lua.G.style.statusline()%}'

return M
