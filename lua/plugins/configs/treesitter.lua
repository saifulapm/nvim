local present, ts_config = pcall(require, 'nvim-treesitter.configs')

if not present then
  return
end

ts_config.setup {
  ensure_installed = {
    'lua',
    'javascript',
    'php',
    'dart',
    'norg',
  },
  highlight = {
    enable = true,
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
  autopairs = { enable = true },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
}
