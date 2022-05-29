local utils = require 'utils.statusline'
local separator = '%='
local end_marker = '%<'
local item = utils.item
local item_if = utils.item_if
local api = vim.api

function _G.__statusline()
  local curwin = vim.g.statusline_winid or 0
  local curbuf = api.nvim_win_get_buf(curwin)

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

  local plain = utils.is_plain(ctx)
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused
  local file_modified = utils.modified(ctx, '●')
  local segments = utils.file(ctx, minimal)
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local markdown_type = ctx.filetype == 'markdown' or false
  local diagnostics = utils.diagnostic_info(ctx)

  local status = vim.b.gitsigns_status_dict or {}
  if minimal then
    local min_tbls = {
      utils.spacer(1),
      item(dir.item, dir.hl, dir.opts),
      item(parent.item, parent.hl, parent.opts),
      item(file.item, file.hl, file.opts),
      item(utils.readonly(ctx), 'StError'),
    }
    return table.concat(min_tbls)
  end
  local tbls = {
    item(utils.mode()),
    item(
      status.head and status.head .. ' ',
      'StGit',
      { prefix = ' ', prefix_color = 'StGit', after = '' }
    ),
    item(utils.readonly(ctx, ''), 'StError'),
    item(dir.item, dir.hl, dir.opts),
    item(parent.item, parent.hl, parent.opts),
    item(file.item, file.hl, file.opts),
    item_if(file_modified, ctx.modified, 'StModified', { before = ' ' }),
    -- item(utils.current_function(), 'StMetadataPrefix', {
    --   before = '  ',
    -- }),
    separator,
    item_if(utils.count_words(), markdown_type, 'StIndicator'),
    separator,
    item(utils.lsp_client(), 'StMetadata'),
    item_if(diagnostics.error.count, diagnostics.error, 'StError', {
      prefix = diagnostics.error.sign,
    }),
    item_if(diagnostics.warning.count, diagnostics.warning, 'StWarning', {
      prefix = diagnostics.warning.sign,
    }),
    item_if(diagnostics.info.count, diagnostics.info, 'StInfo', {
      prefix = diagnostics.info.sign,
    }),
    item(status.changed, 'StTitle', { prefix = '', prefix_color = 'StWarning' }),
    item(status.removed, 'StTitle', { prefix = '', prefix_color = 'StError' }),
    item(status.added, 'StTitle', { prefix = '', prefix_color = 'StGreen' }),
    utils.line_info {
      prefix = 'ℓ',
      prefix_color = 'StMetadataPrefix',
      current_hl = 'StTitle',
      total_hl = 'StComment',
      sep_hl = 'StComment',
    },
    item(utils.ScrollBar()),
    end_marker,
  }
  return table.concat(tbls)
end

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%!v:lua.__statusline()'
