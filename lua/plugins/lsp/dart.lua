local M = {}

M.setup = function(on_attach, capabilities)
  require('flutter-tools').setup {
    ui = { border = 'rounded' },
    debugger = { enabled = false, run_via_dap = false },
    outline = { auto_open = false },
    decorations = {
      statusline = { device = true, app_version = true },
    },
    widget_guides = { enabled = false, debug = true },
    dev_log = { open_cmd = 'tabedit' },
    lsp = {
      settings = {
        showTodos = false,
        renameFilesWithClasses = 'always',
      },
      on_attach = on_attach,
      capabilities = capabilities,
    },
  }
end

return M
