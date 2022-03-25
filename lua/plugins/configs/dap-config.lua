local dap = require 'dap'
local icons = G.style.icons

vim.fn.sign_define('DapBreakpoint', { text = icons.misc.bug, texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

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

local map = require('utils').map
map('n', '<localleader>dt', "<Cmd>lua require'dap'.repl.toggle()<CR>")
map('n', '<localleader>dc', "<Cmd>lua require'dap'.continue()<CR>")
map('n', '<localleader>de', "<Cmd>lua require'dap'.step_out()<CR>")
map('n', '<localleader>di', "<Cmd>lua require'dap'.step_into()<CR>")
map('n', '<localleader>do', "<Cmd>lua require'dap'.step_over()<CR>")
map('n', '<localleader>dl', "<Cmd>lua require'dap'.run_last()<CR>")
map('n', '<localleader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
map(
  'n',
  '<localleader>dB',
  "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input 'Breakpoint condition: ')<CR>"
)
