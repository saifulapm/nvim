local present, neorg = pcall(require, 'neorg')
if not present then
  return
end

neorg.setup {
  load = {
    ['core.defaults'] = {},
    ['core.integrations.telescope'] = {},
    ['core.keybinds'] = {
      config = {
        default_keybinds = true,
        neorg_leader = '<Leader>o',
      },
    },
    ['core.norg.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.norg.concealer'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          notes = '~/Library/Mobile Documents/com~apple~CloudDocs/neorg/main/',
          gtd = '~/Library/Mobile Documents/com~apple~CloudDocs/neorg/tasks/',
        },
      },
    },
    ['core.gtd.base'] = {
      config = {
        workspace = 'tasks',
      },
    },
  },
}

