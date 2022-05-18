local M = {}
local lsp = vim.lsp
local u = require 'utils'

local border_opts = { border = G.style.border.line, focusable = false, scope = 'line' }

-- Show the popup diagnostics window, but only once for the current cursor location
-- by checking whether the word under the cursor has changed.
M.diagnostic_popup = function()
  local cword = vim.fn.expand '<cword>'
  if cword ~= vim.w.lsp_diagnostics_cword then
    vim.w.lsp_diagnostics_cword = cword
    vim.diagnostic.open_float(0, { scope = 'cursor', focus = false })
  end
end

M.lsp_formatting = function(bufnr)
  lsp.buf.format {
    bufnr = bufnr,
    filter = function(clients)
      return vim.tbl_filter(function(client)
        if client.name == 'eslint' then
          return true
        end
        if client.name == 'null-ls' then
          return not u.table.some(clients, function(_, other_client)
            return other_client.name == 'eslint'
          end)
        end
      end, clients)
    end,
  }
end

M.lsp_handlers = function()
  local function lspSymbol(name, icon)
    local hl = 'DiagnosticSign' .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  lspSymbol('Error', G.style.icons.lsp.error)
  lspSymbol('Info', G.style.icons.lsp.info)
  lspSymbol('Hint', G.style.icons.lsp.hint)
  lspSymbol('Warn', G.style.icons.lsp.warn)

  vim.diagnostic.config {
    virtual_text = false,
    float = border_opts,
    signs = true,
    underline = true,
    update_in_insert = false,
  }

  lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, border_opts)
  lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, border_opts)

  -- suppress irrelevant messages
  local notify = vim.notify
  vim.notify = function(msg, ...)
    if msg:match '%[lspconfig%]' then
      return
    end

    if msg:match 'warning: multiple different client offset_encodings' then
      return
    end

    notify(msg, ...)
  end
end

return M
