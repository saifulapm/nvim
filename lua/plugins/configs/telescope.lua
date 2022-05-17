local present, telescope = pcall(require, 'telescope')

if not present then
  return
end

local mappings = require('core.keymaps').mappings.plugins.telescope
local actions = require 'telescope.actions'
local layout_actions = require 'telescope.actions.layout'
local themes = require 'telescope.themes'
local icons = G.style.icons
local map = require('utils').map

local u = require 'utils.color'
u.overwrite {
  { 'TelescopeMatching', { link = 'Title' } },
  { 'TelescopeBorder', { link = 'GreyFloatBorder' } },
  { 'TelescopePromptPrefix', { link = 'Statement' } },
  { 'TelescopeTitle', { inherit = 'Normal', bold = true } },
  { 'TelescopeSelectionCaret', { link = 'Statement' } },
}

local function get_border(opts)
  return vim.tbl_deep_extend('force', opts or {}, {
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
  })
end

---@param opts table
---@return table
local function dropdown(opts)
  return themes.get_dropdown(get_border(opts))
end

telescope.setup {
  defaults = {
    set_env = { ['TERM'] = vim.env.TERM },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    prompt_prefix = icons.misc.telescope .. ' ',
    selection_caret = '» ',
    mappings = {
      i = {
        ['<C-w>'] = actions.send_selected_to_qflist,
        ['<c-c>'] = function()
          vim.cmd 'stopinsert!'
        end,
        ['<esc>'] = actions.close,
        ['<c-s>'] = actions.select_horizontal,
        ['<c-j>'] = actions.cycle_history_next,
        ['<c-k>'] = actions.cycle_history_prev,
        ['<c-e>'] = layout_actions.toggle_preview,
        ['<c-l>'] = layout_actions.cycle_layout_next,
      },
      n = {
        ['<C-w>'] = actions.send_selected_to_qflist,
      },
    },
    file_ignore_patterns = {
      '%.jpg',
      '%.jpeg',
      '%.png',
      '%.otf',
      '%.ttf',
      '%.DS_Store',
      'node_modules',
      'vendor',
    },
    path_display = { 'smart', 'absolute', 'truncate' },
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        preview_width = 0.45,
      },
      cursor = { -- FIXME: this does not change the size of the cursor layout
        width = 0.4,
        height = function(self, _, max_lines)
          local results = #self.finder.results
          return (results <= max_lines and results or max_lines - 10) + 4
        end,
      },
    },
    winblend = 3,
    history = {
      path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
  },
  pickers = {
    buffers = dropdown {
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
    oldfiles = dropdown {
      previewer = false,
    },
    live_grep = {
      file_ignore_patterns = { '.git/' },
    },
    current_buffer_fuzzy_find = dropdown {
      previewer = false,
      shorten_path = false,
    },
    lsp_code_actions = {
      theme = 'cursor',
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = dropdown {
      hidden = true,
      previewer = false,
    },
    git_files = dropdown {
      previewer = false,
    },
    git_branches = dropdown {},
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
    reloader = dropdown {},
  },
}

--- NOTE: this must be required after setting up telescope
--- otherwise the result will be cached without the updates
--- from the setup call
local builtins = require 'telescope.builtin'

local function project_files(opts)
  if not pcall(builtins.git_files, opts) then
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
    ---@diagnostic disable-next-line: missing-parameter
    cwd = vim.fn.expand '$SYNC_DIR/org/',
  }
end

local function norgfiles()
  builtins.find_files {
    prompt_title = 'Norg',
    ---@diagnostic disable-next-line: missing-parameter
    cwd = vim.fn.expand '$SYNC_DIR/neorg/',
  }
end

local function installed_plugins()
  require('telescope.builtin').find_files {
    cwd = vim.fn.stdpath 'data' .. '/site/pack/packer',
  }
end

map('n', mappings.project_files, project_files)
map('n', mappings.builtins, builtins.builtin)
map('n', mappings.current_buffer_fuzzy_find, builtins.current_buffer_fuzzy_find)
map('n', mappings.dotfiles, dotfiles)
-- -- map('n', mappings.dash_app_search, dash)
map('n', mappings.find_files, builtins.find_files)
map('n', mappings.git_commits, builtins.git_commits)
map('n', mappings.git_branches, builtins.git_branches)
-- -- map('n', mappings.pull_requests, prs)
map('n', mappings.man_pages, builtins.man_pages)
map('n', mappings.history, builtins.oldfiles)
map('n', mappings.nvim_config, nvim_config)
map('n', mappings.buffers, builtins.buffers)
map('n', mappings.installed_plugins, installed_plugins)
map('n', mappings.orgfiles, orgfiles)
map('n', mappings.norgfiles, norgfiles)
map('n', mappings.module_reloader, builtins.reloader)
map('n', mappings.resume_last_picker, builtins.resume)
map('n', mappings.grep_string, builtins.live_grep)
-- map('n', mappings.tmux_sessions, tmux_sessions)
-- map('n', mappings.tmux_windows, tmux_windows)
-- map('n', mappings.help_tags, builtins.help_tags)
-- map('n', mappings.lsp_workspace_diagnostics, builtins.lsp_workspace_diagnostics)
-- map('n', mappings.lsp_document_symbols, builtins.lsp_document_symbols)
-- map('n', mappings.lsp_dynamic_workspace_symbols, builtins.lsp_dynamic_workspace_symbols)
