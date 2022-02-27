local null_ls = require 'null-ls'
local b = null_ls.builtins

local sources = {
  b.formatting.prettier.with({
    disabled_filetypes = { "typescript", "typescriptreact" },
  }),
  b.formatting.stylua.with {
    condition = function(utils)
      return utils.root_has_file 'stylua.toml'
    end,
  },
  b.formatting.phpcsfixer.with {
    args = {
      '--no-interaction',
      '--quiet',
      -- '--config=~/.dotfiles/.php-cs-fixer.php',
      'fix',
      '$FILENAME',
    },
  },
  b.formatting.trim_whitespace.with { filetypes = { 'tmux', 'teal', 'zsh' } },
  b.formatting.shfmt,
  b.diagnostics.write_good,
  b.diagnostics.markdownlint,
  -- b.diagnostics.teal,
  b.diagnostics.shellcheck.with { diagnostics_format = '#{m} [#{c}]' },
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,
  b.hover.dictionary,
  b.diagnostics.tsc,
}

local M = {}
M.setup = function(on_attach)
  null_ls.setup {
    -- debug = true,
    sources = sources,
    on_attach = on_attach,
  }
end

return M
