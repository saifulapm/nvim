local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local actions = require 'telescope.actions'
local utils = require "utils"

local plugin_maps = utils.load_config().mappings.plugin
local map = utils.map

telescope.setup {
  defaults = {
    set_env = { ['TERM'] = vim.env.TERM },
    prompt_prefix = ' ',
    selection_caret = '» ',
    mappings = {
      i = {
        ['<c-c>'] = function()
          vim.cmd 'stopinsert!'
        end,
        ['<esc>'] = actions.close,
        ['<c-s>'] = actions.select_horizontal,
        ['<c-j>'] = actions.cycle_history_next,
        ['<c-k>'] = actions.cycle_history_prev,
      },
    },
    file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf' },
    path_display = { 'smart', 'absolute', 'truncate' },
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        preview_width = 0.45,
      },
      width = 0.87,
      height = 0.80,
    },
    winblend = 10,
    history = {
      path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
    },
  },
  extensions = {
    frecency = {
      workspaces = {
        conf = vim.env.DOTFILES,
        project = vim.env.PROJECTS_DIR,
        wiki = vim.g.wiki_path,
      },
    },
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      previewer = false,
      theme = 'dropdown',
      mappings = {
        i = { ['<c-x>'] = 'delete_buffer' },
        n = { ['<c-x>'] = 'delete_buffer' },
      },
    },
    oldfiles = {
      theme = 'dropdown',
    },
    live_grep = {
      file_ignore_patterns = { '.git/' },
    },
    current_buffer_fuzzy_find = {
      theme = 'dropdown',
      previewer = false,
      shorten_path = false,
    },
    lsp_code_actions = {
      theme = 'cursor',
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      hidden = false,
    },
    git_branches = {
      theme = 'dropdown',
    },
    git_bcommits = {
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    },
    git_commits = {
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    },
    reloader = {
      theme = 'dropdown',
    },
  },
}

local builtins = require 'telescope.builtin'

local function project_files(opts)
  local ok = pcall(builtins.git_files, opts)
  if not ok then
    builtins.find_files(opts)
  end
end

local function nvim_config()
  builtins.find_files {
    prompt_title = '~ nvim config ~',
    cwd = vim.fn.stdpath 'config',
    file_ignore_patterns = { '.git/.*', 'dotbot/.*' },
  }
end

local function dotfiles()
  builtins.find_files {
    prompt_title = '~ dotfiles ~',
    cwd = vim.g.dotfiles,
  }
end

local function orgfiles()
  builtins.find_files {
    prompt_title = 'Org',
    cwd = vim.fn.expand '~/Dropbox/org/',
  }
end

local function frecency()
  local themes = require 'telescope.themes'
  telescope.extensions.frecency.frecency(themes.get_dropdown {
    default_text = ':CWD:',
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
end

local function installed_plugins()
  require('telescope.builtin').find_files {
    cwd = vim.fn.stdpath 'data' .. '/site/pack/packer',
  }
end

local function tmux_sessions()
  telescope.extensions.tmux.sessions {}
end

local function tmux_windows()
  telescope.extensions.tmux.windows {
    entry_format = '#S: #T',
  }
end

local m = plugin_maps.telescope

map('n', m.builtins, builtins.builtin)
map("n", m.buffer_fuzzy, builtins.current_buffer_fuzzy_find)
map("n", m.dotfiles, dotfiles)
map("n", m.find_files, builtins.find_files)
map("n", m.find_hiddenfiles, ":Telescope find_files hidden=true <CR>")
map("n", m.git_commits, ":Telescope git_commits <CR>")
map("n", m.git_branches, ":Telescope git_branches <CR>")
map('n', m.man_pages, builtins.man_pages)
map('n', m.nvim_config, nvim_config)
map('n', m.buffers, builtins.buffers)
map('n', m.installed_plugins, installed_plugins)
map('n', m.orgfiles, orgfiles)
map('n', m.module_reloader, builtins.reloader)
map('n', m.resume_last_picker, builtins.resume)
map('n', m.buffers, builtins.buffers)
map("n", m.help_tags, ":Telescope help_tags <CR>")
map("n", m.live_grep, builtins.live_grep)
map("n", m.grep_under_cursor_word, builtins.grep_string)
map("n", m.history, frecency)
map("n", m.tmux_sessions, tmux_sessions)
map("n", m.tmux_windows, tmux_windows)
map("n", m.lsp_workspace_diagnostics, builtins.lsp_workspace_diagnostics)
map("n", m.lsp_document_symbols, builtins.lsp_document_symbols)
map("n", m.lsp_workspace_diagnostics, builtins.lsp_workspace_diagnostics)
