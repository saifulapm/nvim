local M = {}

local config = require('utils').load_config()

M.autopairs = function()
  local present1, autopairs = pcall(require, 'nvim-autopairs')
  local present2, autopairs_completion = pcall(require, 'nvim-autopairs.completion.cmp')

  if not (present1 or present2) then
    return
  end

  autopairs.setup {
    close_triple_quotes = true,
    check_ts = false,
  }
  autopairs_completion.setup {
    map_complete = true, -- insert () func completion
    map_cr = true,
    auto_select = true,
  }
end

M.session = function()
  local present, auto_session = pcall(require, 'auto-session')
  if not present then
    return
  end
  auto_session.setup {
    auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
    auto_session_enabled = false,
    auto_save_enabled = true,
    auto_restore_enabled = false,
    auto_session_suppress_dirs = true,
  }
end

M.better_escape = function()
  require('better_escape').setup {
    mapping = config.mappings.plugin.better_escape.esc_insertmode,
    timeout = config.options.plugin.esc_insertmode_timeout,
  }
end

M.blankline = function()
  require('indent_blankline').setup {
    indentLine_enabled = 1,
    char = '▏',
    filetype_exclude = {
      'help',
      'terminal',
      'dashboard',
      'packer',
      'lspinfo',
      'TelescopePrompt',
      'TelescopeResults',
      'log',
      'fugitive',
      'gitcommit',
      'packer',
      'vimwiki',
      'markdown',
      'txt',
      'vista',
      'NvimTree',
      'git',
      'undotree',
      'flutterToolsOutline',
      'norg',
      'org',
      'orgagenda',
      '', -- for all buffers without a file type
    },
    buftype_exclude = { 'terminal', 'nofile' },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    context_patterns = {
      'class',
      'function',
      'method',
      'block',
      'list_literal',
      'selector',
      '^if',
      '^table',
      'if_statement',
      'while',
      'for',
    },
  }
end

M.colorizer = function()
  local present, colorizer = pcall(require, 'colorizer')
  if present then
    colorizer.setup({ '*' }, {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue
      RRGGBBAA = false, -- #RRGGBBAA hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

      -- Available modes: foreground, background
      mode = 'background', -- Set the display mode.
    })
    vim.cmd 'ColorizerReloadAllBuffers'
  end
end

M.comment = function()
  local present, nvim_comment = pcall(require, 'kommentary.config')
  if present then
    nvim_comment.configure_language(
      'default',
      { ignore_whitespace = true, use_consistent_indentation = true }
    )
    nvim_comment.configure_language({ 'lua', 'php' }, { prefer_single_line_comments = true })
  end
end

M.todo_comments = function()
  local present, todo_comments = pcall(require, 'todo-comments')
  if present then
    todo_comments.setup {
      highlight = {
        exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
      },
    }
  end
end

M.neoscroll = function()
  pcall(function()
    require('neoscroll').setup {
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
      stop_eof = false,
      hide_cursor = true,
    }
  end)
end

M.signature = function()
  local present, lspsignature = pcall(require, 'lsp_signature')
  if present then
    lspsignature.setup {
      bind = true,
      fix_pos = false,
      hint_enable = true,
      handler_opts = {
        border = 'rounded', -- double, single, shadow, none
      },
    }
  end
end

M.fastaction = function()
  local present, fastaction = pcall(require, 'lsp-fastaction')
  if present then
    fastaction.setup {
      action_data = {
        dart = {
          { pattern = 'import library', key = 'i', order = 1 },
          { pattern = 'wrap with widget', key = 'w', order = 2 },
          { pattern = 'column', key = 'c', order = 3 },
          { pattern = 'row', key = 'r', order = 3 },
          { pattern = 'container', key = 'C', order = 4 },
          { pattern = 'center', key = 'E', order = 4 },
          { pattern = 'padding', key = 'p', order = 4 },
          { pattern = 'remove', key = 'r', order = 5 },
          -- range code action
          { pattern = "surround with %'if'", key = 'i', order = 2 },
          { pattern = 'try%-catch', key = 't', order = 2 },
          { pattern = 'for%-in', key = 'f', order = 2 },
          { pattern = 'setstate', key = 's', order = 2 },
        },
      },
    }
  end
end

M.null_ls = function()
  local present1, null_ls = pcall(require, 'null-ls')
  local present2, lspconfig = pcall(require, 'lspconfig')

  if not (present1 or present2) then
    return
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
  lspconfig['null-ls'].setup { on_attach = gl.lsp.on_attach }
end

M.hop = function()
  local present, hop = pcall(require, 'hop')
  if not present then
    return
  end

  -- remove h,j,k,l from hops list of keys
  hop.setup { keys = 'etovxqpdygfbzcisuran' }
end

M.neoclip = function()
  local present, neoclip = pcall(require, 'neoclip')
  if present then
    neoclip.setup {
      keys = {
        i = { select = '<CR>', paste = '<c-p>', paste_behind = '<c-k>' },
        n = { select = '<CR>', paste = 'p', paste_behind = 'P' },
      },
    }
    local function clip()
      if not gl.plugin_loaded 'telescope' then
        vim.cmd [[packadd telescope.nvim]]
      end
      require('telescope').extensions.neoclip.default(require('telescope.themes').get_dropdown())
    end
    local map = require('utils').map
    map('n', '<localleader>p', clip)
  end
end

return M
