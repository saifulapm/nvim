local present, ts_config = pcall(require, 'nvim-treesitter.configs')
if not present then
  return
end

-- local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
-- parser_configs.norg = {
--   install_info = {
--     url = 'https://github.com/nvim-neorg/tree-sitter-norg',
--     files = { 'src/parser.c', 'src/scanner.cc' },
--     branch = 'main',
--   },
-- }

ts_config.setup {
  ensure_installed = {
    'lua',
    'javascript',
    'php',
    -- 'norg',
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- mappings for incremental selection (visual mappings)
      init_selection = '<leader>v', -- maps in normal mode to init the node/scope selection
      node_incremental = '<leader>v', -- increment to the upper named parent
      node_decremental = '<leader>V', -- decrement to the previous node
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@conditional.outer',
        ['iC'] = '@conditional.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['[w'] = '@parameter.inner',
      },
      swap_previous = {
        [']w'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
    },
  },
}
