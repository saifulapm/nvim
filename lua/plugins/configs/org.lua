local present, neorg = pcall(require, 'neorg')

if not present then
  return
end

neorg.setup {
  load = {
    ['core.defaults'] = {},
    ['core.keybinds'] = {
      config = {
        default_keybinds = true,
        neorg_leader = '<localleader>',
      },
    },
    ['core.norg.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.norg.concealer'] = {
      config = {
        -- markup_preset = "dimmed",
        markup_preset = 'conceal',
        icon_preset = 'diamond',
        icons = {
          marker = {
            icon = ' ',
          },
          todo = {
            enable = true,
            pending = {
              -- icon = ""
              icon = '',
            },
            uncertain = {
              icon = '?',
            },
            urgent = {
              icon = '',
            },
            on_hold = {
              icon = '',
            },
            cancelled = {
              icon = '',
            },
          },
        },
      },
    },
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          notes = vim.fn.expand '$SYNC_DIR/neorg/main/',
          tasks = vim.fn.expand '$SYNC_DIR/neorg/tasks/',
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

vim.keymap.set('n', '<localleader>oc', '<Cmd>Neorg gtd capture<CR>')
vim.keymap.set('n', '<localleader>ov', '<Cmd>Neorg gtd views<CR>')
