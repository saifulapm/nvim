local present, tree_c = pcall(require, "nvim-tree.config")
if not present then
   return
end

vim.g.nvim_tree_icons = {
  default = '',
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = '',
    untracked = '',
    deleted = '',
  },
}

vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_auto_close = 0 -- closes the tree when it's the last window
vim.g.nvim_tree_follow = 1 -- show selected file on open
vim.g.nvim_tree_width = '20%'
vim.g.nvim_tree_width_allow_resize = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 1
vim.g.nvim_tree_root_folder_modifier = ':t'
vim.g.nvim_tree_ignore = { '.DS_Store', 'fugitive:', '.git' }
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_auto_resize = 1

local action = tree_c.nvim_tree_callback
vim.g.nvim_tree_bindings = {
  { key = 'cd', cb = action 'cd' },
  { key = "v", cb = action("vsplit") },
  { key = "s", cb = action("split") },
}
