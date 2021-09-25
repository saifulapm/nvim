local present, null_ls = pcall(require, 'null_ls')
if not present then
  return
end

null_ls.config {
  debounce = 150,
  sources = {
    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.formatting.stylua.with {
      condition = function(_utils)
        return _utils.root_has_file 'stylua.toml'
      end,
    },
    null_ls.builtins.formatting.prettier.with {
      filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
    },
    -- FIXME: It's working right now
    null_ls.builtins.formatting.phpcsfixer.with {
      args = {
        '--no-interaction',
        '--quiet',
        '--config=~/.dotfiles/.php-cs-fixer.php',
        'fix',
        '$FILENAME',
      },
    },
  },
}
require('lspconfig')['null-ls'].setup { on_attach = gl.lsp.on_attach }
