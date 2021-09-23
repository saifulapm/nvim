gl.lsp = {}

--- TODO: remove once 0.6 is stable (use vim.diagnostic)
local diagnostics = gl.nightly and vim.diagnostic or vim.lsp.diagnostic

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client, _)
  if client and client.resolved_capabilities.code_lens then
    gl.augroup('LspCodeLens', {
      {
        events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        targets = { '<buffer>' },
        command = vim.lsp.codelens.refresh,
      },
    })
  end
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    gl.augroup('LspFormat', {
      {
        events = { 'BufWritePre' },
        targets = { '<buffer>' },
        command = function()
          -- BUG: folds are are removed when formatting is done, so we save the current state of the
          -- view and re-apply it manually after formatting the buffer
          -- @see: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
          vim.cmd 'mkview!'
          vim.lsp.buf.formatting_sync()
          vim.cmd 'edit | loadview'
        end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
---@param bufnr integer?
local function setup_mappings(client, bufnr)
  local map = require("utils").map
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gI", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
  map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  map("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  map("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  map("n", "[d", function()
    diagnostics.goto_prev { popup_opts = { border = 'rounded', focusable = false } }
  end)
  map("n", "]d", function()
    diagnostics.goto_next { popup_opts = { border = 'rounded', focusable = false } }
  end)
  map("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
  map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  if client.resolved_capabilities.implementation then
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  end

  if client.resolved_capabilities.type_definition then
    map("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  end

  if not gl.has_map('<leader>ca', 'n') then
    map("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    map("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>")
  end

  if client.supports_method 'textDocument/rename' then
    map("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
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

function gl.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)

  if client.resolved_capabilities.goto_definition then
    vim.bo[bufnr].tagfunc = 'v:lua.gl.lsp.tagfunc'
  end
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- LSP server configs are setup dynamically gl they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
gl.lsp.servers = {
  lua = function()
    --- NOTE: This is the secret sauce that allows reading requires and variables
    --- between different modules in the nvim lua context
    --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
    --- if I ever decide to move away from lua dev then use the above
    return require('lua-dev').setup {
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
    }
  end,
}

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
function gl.lsp.setup_servers()
  local lspconfig = require 'lspconfig'
  local install_ok, lspinstall = gl.safe_require 'lspinstall'
  local nvim_lsp_ok, cmp_nvim_lsp = gl.safe_require 'cmp_nvim_lsp'
  -- can't reasonably proceed if lspinstall isn't loaded
  if not install_ok then
    return
  end

  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  for _, server in pairs(installed) do
    local config = gl.lsp.servers[server] and gl.lsp.servers[server]() or {}
    config.flags = { debounce_text_changes = 500 }
    config.on_attach = gl.lsp.on_attach
    config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
    if nvim_lsp_ok then
      cmp_nvim_lsp.update_capabilities(config.capabilities)
    end
    lspconfig[server].setup(config)
  end
  vim.cmd 'doautocmd User LspServersStarted'
end

if vim.g.lspconfig_has_setup then
  return
end
vim.g.lspconfig_has_setup = true

gl.lsp.setup_servers()

