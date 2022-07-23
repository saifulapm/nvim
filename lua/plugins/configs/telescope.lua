local present, telescope = pcall(require, 'telescope')

if not present then
  return
end

require('colors').load_highlight 'telescope'

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = { 'node_modules' },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = { 'truncate' },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
    mappings = {
      n = { ['q'] = require('telescope.actions').close },
    },
  },
}

--
-- map('n', mappings.project_files, project_files)
-- map('n', mappings.builtins, builtins.builtin)
-- map('n', mappings.current_buffer_fuzzy_find, builtins.current_buffer_fuzzy_find)
-- map('n', mappings.dotfiles, dotfiles)
-- -- -- map('n', mappings.dash_app_search, dash)
-- map('n', mappings.find_files, builtins.find_files)
-- map('n', mappings.git_commits, builtins.git_commits)
-- map('n', mappings.git_branches, builtins.git_branches)
-- -- -- map('n', mappings.pull_requests, prs)
-- map('n', mappings.man_pages, builtins.man_pages)
-- map('n', mappings.history, builtins.oldfiles)
-- map('n', mappings.nvim_config, nvim_config)
-- map('n', mappings.buffers, builtins.buffers)
-- map('n', mappings.installed_plugins, installed_plugins)
-- map('n', mappings.orgfiles, orgfiles)
-- map('n', mappings.norgfiles, norgfiles)
-- map('n', mappings.module_reloader, builtins.reloader)
-- map('n', mappings.resume_last_picker, builtins.resume)
-- map('n', mappings.grep_string, builtins.live_grep)
-- map('n', mappings.file_browser, '<cmd>Telescope file_browser<cr>')
-- map('n', mappings.tmux_sessions, tmux_sessions)
-- map('n', mappings.tmux_windows, tmux_windows)
-- map('n', mappings.help_tags, builtins.help_tags)
-- map('n', mappings.lsp_workspace_diagnostics, builtins.lsp_workspace_diagnostics)
-- map('n', mappings.lsp_document_symbols, builtins.lsp_document_symbols)
-- map('n', mappings.lsp_dynamic_workspace_symbols, builtins.lsp_dynamic_workspace_symbols)
