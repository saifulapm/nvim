local M = {}
local lsp = vim.lsp
local api = vim.api

-- use lsp formatting if it's available (and if it's good)
-- otherwise, fall back to null-ls
local preferred_formatting_clients = { 'denols', 'eslint' }
local fallback_formatting_client = 'null-ls'

-- prevent repeated lookups
local buffer_client_ids = {}

local border_opts = { border = G.style.border.line, focusable = false, scope = 'line' }

M.formatting = function(bufnr)
  bufnr = tonumber(bufnr) or api.nvim_get_current_buf()

  local selected_client
  if buffer_client_ids[bufnr] then
    selected_client = lsp.get_client_by_id(buffer_client_ids[bufnr])
  else
    for _, client in ipairs(lsp.buf_get_clients(bufnr)) do
      if vim.tbl_contains(preferred_formatting_clients, client.name) then
        selected_client = client
        break
      end

      if client.name == fallback_formatting_client then
        selected_client = client
      end
    end
  end

  if not selected_client then
    return
  end

  buffer_client_ids[bufnr] = selected_client.id

  local params = lsp.util.make_formatting_params()
  selected_client.request('textDocument/formatting', params, function(err, res)
    if err then
      local err_msg = type(err) == 'string' and err or err.message
      vim.notify('global.lsp.formatting: ' .. err_msg, vim.log.levels.WARN)
      return
    end

    if not api.nvim_buf_is_loaded(bufnr) or api.nvim_buf_get_option(bufnr, 'modified') then
      return
    end

    if res then
      lsp.util.apply_text_edits(res, bufnr, selected_client.offset_encoding or 'utf-16')
      api.nvim_buf_call(bufnr, function()
        vim.cmd 'silent noautocmd update'
      end)
    end
  end, bufnr)
end

M.lsp_handlers = function()
  local function lspSymbol(name, icon)
    local hl = 'DiagnosticSign' .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  lspSymbol('Error', G.style.icons.error)
  lspSymbol('Info', G.style.icons.info)
  lspSymbol('Hint', G.style.icons.hint)
  lspSymbol('Warn', G.style.icons.warn)

  vim.diagnostic.config {
    virtual_text = {
      prefix = '',
    },
    float = border_opts,
    signs = true,
    underline = true,
    update_in_insert = false,
  }

  lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, border_opts)
  lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, border_opts)

  -- suppress error messages from lang servers
  vim.notify = function(msg, log_level)
    if msg:match 'exit code' then
      return
    end
    if log_level == vim.log.levels.ERROR then
      api.nvim_err_writeln(msg)
    else
      api.nvim_echo({ { msg } }, true, {})
    end
  end
end

return M
