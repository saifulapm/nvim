gl.lsp = {}
local command = gl.command
local map = require('utils').map
local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local null_ls = require 'null-ls'

command {
  'LspLog',
  function()
    vim.cmd('edit ' .. vim.lsp.get_log_path())
  end,
}

command {
  'LspFormat',
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
}

local function setup_mappings(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('n', 'gI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  map('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map(
    'n',
    '<space>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    opts
  )
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  map('n', '[d', function()
    vim.lsp.diagnostic.goto_prev {
      popup_opts = { border = 'rounded', focusable = false, source = 'always' },
    }
  end, opts)
  map('n', ']d', function()
    vim.lsp.diagnostic.goto_next {
      popup_opts = { border = 'rounded', focusable = false, source = 'always' },
    }
  end, opts)
  map('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  if client.resolved_capabilities.implementation then
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  end

  if client.resolved_capabilities.type_definition then
    map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  end

  if not gl.has_map('<leader>ca', 'n') then
    map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map('v', '<space>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  end

  if client.supports_method 'textDocument/rename' then
    map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  end
end

function gl.lsp.tagfunc(pattern, flags)
  if flags ~= 'c' then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(
    0,
    'textDocument/definition',
    params,
    500
  )
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(results, {
        name = pattern,
        filename = vim.uri_to_fname(location.uri),
        cmd = string.format('call cursor(%d, %d)', start.line + 1, start.character + 1),
      })
    end
  end
  return results
end

local function setup_autocommands(client, _)
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    gl.augroup('LspFormat', {
      {
        events = { 'BufWritePre' },
        targets = { '<buffer>' },
        command = function()
          vim.lsp.diagnostic.set_loclist { open_loclist = false }
          vim.lsp.buf.formatting_sync()
        end,
      },
    })
  end
end

local function on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)

  if client.resolved_capabilities.goto_definition then
    vim.bo[bufnr].tagfunc = 'v:lua.gl.lsp.tagfunc'
  end
end

null_ls.config {
  debounce = 150,
  sources = {
    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.stylua.with {
      condition = function(_utils)
        return _utils.root_has_file 'stylua.toml'
      end,
    },
    null_ls.builtins.formatting.prettier.with {
      filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
    },
  },
}
require('lspconfig')['null-ls'].setup { on_attach = on_attach }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = {
  'markdown',
  'plaintext',
}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

local prefix = 'LspDiagnosticsSign'

local diagnostic_types = {
  { 'Hint', icon = gl.style.icons.hint },
  { 'Error', icon = gl.style.icons.error },
  { 'Warning', icon = gl.style.icons.warning },
  { 'Information', icon = gl.style.icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = prefix .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = fmt('%sLine', hl),
  }
end, diagnostic_types))

---Override diagnostics signs helper to only show the single most relevant sign
---@see: http://reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a
---@param diagnostics table[]
---@param bufnr number
---@return table[]
local function filter_diagnostics(diagnostics, bufnr)
  if not diagnostics then
    return {}
  end
  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    local lnum = d.range.start.line
    if max_severity_per_line[lnum] then
      local current_d = max_severity_per_line[lnum]
      if d.severity < current_d.severity then
        max_severity_per_line[lnum] = d
      end
    else
      max_severity_per_line[lnum] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for _, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end
  return filtered_diagnostics
end

-- Capture real implementation of function that sets signs
local set_signs = vim.lsp.diagnostic.set_signs
---@param diagnostics table
---@param bufnr number
---@param client_id number
---@param sign_ns number
---@param opts table
vim.lsp.diagnostic.set_signs = function(diagnostics, bufnr, client_id, sign_ns, opts)
  local filtered = filter_diagnostics(diagnostics, bufnr)
  -- call original function
  set_signs(filtered, bufnr, client_id, sign_ns, opts)
end

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded', max_width = max_width, max_height = max_height }
)

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- LSP server configs are setup dynamically gl they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
local servers = {
  sumneko_lua = require('lua-dev').setup {
    lspconfig = {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
              'describe',
              'it',
              'before_each',
              'after_each',
              'pending',
              'teardown',
              'packer_plugins',
            },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        },
      },
    },
  },
}

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
local get_server_config = function(server)
  local conf = servers[server.name]
  local config = type(conf) == 'table' and conf or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = on_attach
  config.capabilities = capabilities
  return config
end

vim.g.lspconfig_has_setup = true
local lsp_installer = require 'nvim-lsp-installer'
lsp_installer.on_server_ready(function(server)
  server:setup(get_server_config(server))
  vim.cmd [[ do User LspAttachBuffers ]]
end)
