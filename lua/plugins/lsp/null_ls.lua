local null_ls = require 'null-ls'
local b = null_ls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = '#{m} [#{c}]',
  }
end

local with_root_file = function(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  }
end

local sources = {
  -- formatting
  b.formatting.prettier.with { filetypes = { 'html', 'markdown', 'css' } },
  -- with_root_file(b.formatting.prettier, '.prettierrc'),
  -- b.formatting.fish_indent,
  -- b.formatting.shfmt,
  -- b.formatting.trim_whitespace.with({ filetypes = { "tmux", "teal" } }),
  with_root_file(b.formatting.stylua, 'stylua.toml'),
  b.formatting.phpcsfixer.with {
    args = {
      '--no-interaction',
      '--quiet',
      '--config=/home/saiful/.dotfiles/.php-cs-fixer.dist.php',
      'fix',
      '$FILENAME',
    },
  },
  -- diagnostics
  -- b.diagnostics.phpstan,
  -- with_root_file(b.diagnostics.selene, "selene.toml"),
  -- b.diagnostics.write_good,
  -- b.diagnostics.markdownlint,
  -- b.diagnostics.teal,
  -- b.diagnostics.tsc,
  with_diagnostics_code(b.diagnostics.shellcheck),
  -- -- code actions
  -- b.code_actions.gitsigns,
  -- b.code_actions.gitrebase,
  -- -- hover
  -- b.hover.dictionary,
}

local M = {}
M.setup = function(_)
  null_ls.setup {
    sources = sources,
    on_attach = function(client)
      require('lsp-format').on_attach(client)
    end,
  }
end

return M
