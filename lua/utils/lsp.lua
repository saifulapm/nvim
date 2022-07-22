local M = {}
local lsp = vim.lsp

local border_opts = { border = G.style.border.line, focusable = false, scope = 'line' }

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
