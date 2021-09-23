local M = {}

local config = require("utils").load_config()

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, autopairs_completion = pcall(require, "nvim-autopairs.completion.cmp")

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

M.autosave = function()
   -- autosave.nvim plugin is disabled by default
   local present, autosave = pcall(require, "autosave")
   if not present then
      return
   end

   autosave.setup {
      enabled = config.options.plugin.autosave, -- takes boolean value from chadrc.lua
      execution_message = "autosaved at : " .. vim.fn.strftime "%H:%M:%S",
      events = { "InsertLeave", "TextChanged" },
      conditions = {
         exists = true,
         filetype_is_not = {},
         modifiable = true,
      },
      clean_command_line_interval = 2500,
      on_off_commands = true,
      write_all_buffers = false,
   }
end

M.better_escape = function()
   local m = require("utils").load_config().mappings.plugin.better_escape.esc_insertmode

   vim.g.better_escape_interval = config.options.plugin.esc_insertmode_timeout or 300
   vim.g.better_escape_shortcut = m
end

M.blankline = function()
   require("indent_blankline").setup {
      indentLine_enabled = 1,
      char = "▏",
      filetype_exclude = {
         "help",
         "terminal",
         "dashboard",
         "packer",
         "lspinfo",
         "TelescopePrompt",
         "TelescopeResults",
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
      buftype_exclude = { "terminal", 'nofile' },
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
      }
   }
end

M.colorizer = function()
   local present, colorizer = pcall(require, "colorizer")
   if present then
      colorizer.setup({ "*" }, {
         RGB = true, -- #RGB hex codes
         RRGGBB = true, -- #RRGGBB hex codes
         names = false, -- "Name" codes like Blue
         RRGGBBAA = false, -- #RRGGBBAA hex codes
         rgb_fn = false, -- CSS rgb() and rgba() functions
         hsl_fn = false, -- CSS hsl() and hsla() functions
         css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
         css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

         -- Available modes: foreground, background
         mode = "background", -- Set the display mode.
      })
      vim.cmd "ColorizerReloadAllBuffers"
   end
end

M.comment = function()
   local present, nvim_comment = pcall(require, "kommentary.config")
   if present then
      nvim_comment.configure_language ('default', { ignore_whitespace = true, use_consistent_indentation = true })
      nvim_comment.configure_language ( {'lua', 'php' }, { prefer_single_line_comments = true })
  end
end

M.todo_comments = function()
   local present, todo_comments = pcall(require, "todo-comments")
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
    require("neoscroll").setup {
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
      stop_eof = false,
      hide_cursor = true,
    }
   end)
end

M.signature = function()
   local present, lspsignature = pcall(require, "lsp_signature")
   if present then
      lspsignature.setup {
         bind = true,
         doc_lines = 2,
         floating_window = true,
         fix_pos = true,
         hint_enable = true,
         hint_prefix = " ",
         hint_scheme = "String",
         hi_parameter = "Search",
         max_height = 22,
         max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
         handler_opts = {
            border = "single", -- double, single, shadow, none
         },
         zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
         padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
      }
   end
end

M.fastaction = function()
  local present, fastaction = pcall(require, "lsp-fastaction")
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

M.null_ls = function ()
  local present1, null_ls = pcall(require, "null-ls")
  local present2,  lspconfig = pcall(require, "lspconfig")

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

M.hop = function ()
  local present1, hop = pcall(require, "hop")
  local present2, hint = pcall(require, "hop.hint")
  if not (present1 or present2) then
    return
  end

  -- remove h,j,k,l from hops list of keys
  hop.setup { keys = 'etovxqpdygfbzcisuran' }

  local map = require("utils").map

  -- NOTE: override F/f using hop motions
  map('n', 'F', function()
    hop.hint_words { direction = hint.HintDirection.BEFORE_CURSOR }
  end)

  map('n', 'f', function()
    hop.hint_words { direction = hint.HintDirection.AFTER_CURSOR }
  end)

  map({ 'o', 'x' }, 'F', function()
    hop.hint_char1 { direction = hint.HintDirection.BEFORE_CURSOR }
  end)
  map({ 'o', 'x' }, 'f', function()
    hop.hint_char1 { direction = hint.HintDirection.AFTER_CURSOR }
  end)
end

return M
