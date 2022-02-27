local dap = require 'dap'

dap.adapters = {
  chrome = {
    type = 'executable',
    command = 'node',
    args = {
      os.getenv 'HOME' .. '/sdk/vscode-chrome-debug/out/src/chromeDebug.js',
      '--remote-debugging-port',
      '9222',
    },
  },
  php = {
    type = 'executable',
    command = 'node',
    args = { os.getenv 'HOME' .. '/sdk/vscode-php-debug/out/phpDebug.js' },
  },
  dart = {
    type = 'executable',
    command = 'node',
    args = { os.getenv 'HOME' .. '/sdk/Dart-Code/out/dist/debug.js', 'flutter' },
  },
}

local configs = {
  chrome = {
    type = 'chrome',
    request = 'launch',
    name = 'chrome-debug',
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}',
    sourceMaps = true,
  },
  php = {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = '9003',
    log = false,
  },
  dart = {
    type = 'dart',
    request = 'launch',
    name = 'Launch flutter',
    dartSdkPath = os.getenv 'HOME' .. '/sdk/flutter/bin/cache/dart-sdk/',
    flutterSdkPath = os.getenv 'HOME' .. '/sdk/flutter',
    program = '${workspaceFolder}/lib/main.dart',
    cwd = '${workspaceFolder}',
  },
}

dap.configurations = {
  javascript = { configs.chrome },
  php = { configs.php },
  dart = { configs.dart },
}

vim.cmd "command! DapContinue lua require'dap'.continue()"
vim.cmd "command! DapBreakpoint lua require'dap'.toggle_breakpoint()"
vim.cmd "command! DapRepl lua require'dap'.repl.open()"
vim.cmd "command! DapScopes lua require'dap.ui.variables'.scopes()"
vim.cmd "command! DapHover lua require'dap.ui.variables'.visual_hover()"
vim.cmd "command! DapStepOut lua require'dap'.step_out()"
vim.cmd "command! DapStepOver lua require'dap'.step_over()"
vim.cmd "command! DapStepInto lua require'dap'.step_into()"
