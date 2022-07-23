local M = {}

M.lsp_handlers = function()
  -- Signs
  local function sign(opts)
    vim.fn.sign_define(opts.highlight, {
      text = opts.icon,
      texthl = opts.highlight,
      culhl = opts.highlight .. 'Line',
    })
  end

  sign { highlight = 'DiagnosticSignError', icon = G.style.icons.lsp.error }
  sign { highlight = 'DiagnosticSignWarn', icon = G.style.icons.lsp.warn }
  sign { highlight = 'DiagnosticSignInfo', icon = G.style.icons.lsp.info }
  sign { highlight = 'DiagnosticSignHint', icon = G.style.icons.lsp.hint }

  -- Diagnostic Configuration
  local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
  local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

  vim.diagnostic.config {
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
      spacing = 1,
      prefix = '',
      format = function(d)
        local level = vim.diagnostic.severity[d.severity]
        return string.format('%s %s', G.style.icons.lsp[level:lower()], d.message)
      end,
    },
    float = {
      max_width = max_width,
      max_height = max_height,
      border = G.style.border.line,
      focusable = false,
      source = 'always',
      prefix = function(diag, i, _)
        local level = vim.diagnostic.severity[diag.severity]
        local prefix = string.format('%d. %s ', i, G.style.icons.lsp[level:lower()])
        return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
      end,
    },
  }

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = G.style.border.line,
    max_width = max_width,
    max_height = max_height,
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = G.style.border.line,
    max_width = max_width,
    max_height = max_height,
  })

  vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
    vim.notify(result.message, lvl, {
      title = 'LSP | ' .. client.name,
      timeout = 8000,
      keep = function()
        return lvl == 'ERROR' or lvl == 'WARN'
      end,
    })
  end
end

return M
