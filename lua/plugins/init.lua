local present, packer = pcall(require, 'utils.plugins')

if not present then
  return false
end

local use = packer.use

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

return packer.startup(function()
  -- Core Plugin {{{
  use {
    { 'wbthomason/packer.nvim', opt = true },
    { 'nvim-lua/plenary.nvim' },
    { 'lewis6991/impatient.nvim' },
    {
      'lewis6991/gitsigns.nvim',
      after = 'plenary.nvim',
      config = function()
        require 'plugins.configs.gitsigns'
      end,
    },
    {
      '~/Sites/nvim/base46',
      config = function()
        require('base46').load_theme()
      end,
    },
    { 'kyazdani42/nvim-web-devicons' },
    {
      'numToStr/Comment.nvim',
      keys = { { 'n', 'gcc' }, { 'v', 'gc' } },
      config = function()
        require('Comment').setup {}
      end,
    },
  }
  -- }}}

  -- UI Plugin {{{
  use {
    {
      'akinsho/bufferline.nvim',
      tag = '*',
      config = function()
        require 'plugins.configs.bufferline'
      end,
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufRead',
      config = function()
        require 'plugins.configs.blankline'
      end,
    },
    {
      'stevearc/dressing.nvim',
      after = 'telescope.nvim',
      config = function()
        require 'plugins.configs.dressing'
      end,
    },
    {
      'folke/todo-comments.nvim',
      event = 'BufRead',
      config = function()
        -- this plugin is not safe to reload
        if vim.g.packer_compiled_loaded then
          return
        end
        require('todo-comments').setup {
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        }
        vim.keymap.set('n', '<leader>lt', '<Cmd>TodoTrouble<CR>')
      end,
    },
    {
      'b0o/incline.nvim',
      config = function()
        require('incline').setup {
          hide = {
            focused_win = true,
          },
        }
      end,
    },
  }
  -- }}}

  --- LSP Staff {{{
  use {
    {
      'neovim/nvim-lspconfig',
      ft = {
        'lua',
        'php',
        'liquid',
        'vue',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'html',
      },
      config = function()
        require 'plugins.lsp'
      end,
      requires = {
        { 'folke/lua-dev.nvim', opt = true },
        { 'hrsh7th/cmp-nvim-lsp', opt = true },
        { 'jose-elias-alvarez/null-ls.nvim', opt = true },
        { 'williamboman/nvim-lsp-installer', opt = true },
        { 'jose-elias-alvarez/typescript.nvim', opt = true },
        { 'lukas-reineke/lsp-format.nvim', opt = true },
      },
    },
    {
      'ray-x/lsp_signature.nvim',
      after = 'nvim-lspconfig',
      config = function()
        require('lsp_signature').setup {
          bind = true,
          fix_pos = false,
          auto_close_after = 15, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = G.style.border.line },
          toggle_key = '<C-K>',
          select_signature_key = '<A-N>',
        }
      end,
    },
    {
      'j-hui/fidget.nvim',
      after = 'nvim-lspconfig',
      config = function()
        require('fidget').setup()
      end,
    },
    {
      'folke/trouble.nvim',
      cmd = 'TroubleToggle',
      config = [[require('plugins.configs.trouble')]],
    },
    {
      'rmagatti/goto-preview',
      config = function()
        require('goto-preview').setup {
          width = 120,
          height = 30,
          default_mappings = true,
          border = G.style.border.line,
        }
      end,
      keys = { 'gpd', 'gpi', 'gpr' },
    },
    {
      'simrat39/symbols-outline.nvim',
      cmd = { 'SymbolsOutline' },
      setup = function()
        vim.g.symbols_outline = {
          border = G.style.border.line,
          auto_preview = false,
        }
      end,
    },
  }
  -- }}}

  --- Completion {{{
  use {
    {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = { 'BufRead' },
      requires = {
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      },
      config = function()
        require 'plugins.configs.cmp'
      end,
    },
    {
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function()
        require('tabout').setup {
          completion = false,
          ignore_beginning = false,
        }
      end,
    },
    {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      config = function()
        require 'plugins.configs.luasnip'
      end,
    },
    {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup {
          close_triple_quotes = true,
          check_ts = true,
          ts_config = {
            lua = { 'string' },
            dart = { 'string' },
            javascript = { 'template_string' },
          },
          fast_wrap = {
            map = '<c-e>',
          },
        }
      end,
    },
    {
      'github/copilot.vim',
      after = 'nvim-cmp',
      setup = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ''
        vim.g.copilot_filetypes = {
          ['*'] = true,
          gitcommit = false,
          NeogitCommitMessage = false,
          DressingInput = false,
          ['neo-tree-popup'] = false,
        }
        vim.keymap.set('i', '<C-h>', "copilot#Accept('<Tab>')", { expr = true, noremap = false })
        vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)')
        vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)')
        vim.keymap.set('i', '<C-\\>', '<Cmd>vertical Copilot panel<CR>')
      end,
    },
  }
  -- }}}

  -- Telescope & Treesitter {{{
  use {
    {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      config = function()
        require 'plugins.configs.telescope'
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      event = 'BufRead',
      config = function()
        require 'plugins.configs.treesitter'
      end,
    },
  }
  -- }}}

  --- Editor Helper {{{
  use {
    {
      'kyazdani42/nvim-tree.lua',
      cmd = 'NvimTreeToggle',
      requires = 'nvim-web-devicons',
      config = function()
        require 'plugins.configs.nvimtree'
      end,
      setup = function()
        require('core.mappings').nvimtree()
      end,
    },
    {
      'norcalli/nvim-colorizer.lua',
      cmd = {
        'ColorizerToggle',
        'ColorizerAttachToBuffer',
        'ColorizerDetachFromBuffer',
        'ColorizerReloadAllBuffers',
      },
      config = function()
        require('colorizer').setup({ '*' }, {
          RGB = false,
          mode = 'background',
        })
      end,
    },
    {
      'monaqa/dial.nvim',
      keys = { { 'n', '<C-a>' }, { 'n', '<C-x>' }, { 'v', '<C-a>' }, { 'v', '<C-x>' } },
      config = function()
        require 'plugins.configs.dial'
      end,
    },
    {
      'numToStr/FTerm.nvim',
      opt = true,
      config = function()
        require('FTerm').setup {
          border = G.style.border.line,
          hl = 'NormalFloat',
          dimensions = {
            height = 0.4,
            width = 0.9,
          },
        }
      end,
    },
    {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      config = function()
        vim.g.undotree_TreeNodeShape = '◉' -- Alternative: '◦'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    },
    {
      'chentau/marks.nvim',
      keys = { { 'n', 'm' } },
      config = function()
        require('marks').setup {
          bookmark_0 = {
            sign = '⚑',
            virt_text = 'bookmarks',
          },
        }
      end,
    },
    {
      'rmagatti/auto-session',
      -- event = 'BufRead',
      -- cmd = 'RestoreSession',
      config = function()
        local fn = vim.fn
        local fmt = string.format
        local data = fn.stdpath 'data'
        require('auto-session').setup {
          log_level = 'error',
          auto_session_root_dir = fmt('%s/session/auto/', data),
          -- Do not enable auto restoration in my projects directory, I'd like to choose projects myself
          auto_restore_enabled = not vim.startswith(fn.getcwd(), vim.env.PROJECTS_DIR),
          auto_session_suppress_dirs = {
            vim.env.HOME,
            vim.env.PROJECTS_DIR,
            fmt('%s/Desktop', vim.env.HOME),
            fmt('%s/site/pack/packer/opt/*', data),
            fmt('%s/site/pack/packer/start/*', data),
          },
          auto_session_use_git_branch = false, -- This cause inconsistent results
        }
      end,
    },
    {
      'Krafi2/jeskape.nvim',
      event = 'InsertEnter',
      config = function()
        require('jeskape').setup {
          mappings = {
            jk = '<esc>',
            kj = '<esc>',
            [';;'] = '<esc>A;',
          },
          timeout = 300,
        }
      end,
    },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-sleuth' },
    { 'antoinemadec/FixCursorHold.nvim' },
    {
      'andymass/vim-matchup',
      opt = true,
      setup = function()
        require('utils').lazy 'vim-matchup'
      end,
    },
    {
      'anuvyklack/hydra.nvim',
      requires = 'anuvyklack/keymap-layer.nvim',
      config = function()
        if vim.g.packer_compiled_loaded then
          return
        end
        require 'plugins.configs.hydra'
      end,
    },
    {
      'AndrewRadev/splitjoin.vim',
      keys = {
        { 'n', 'gJ' },
        { 'n', 'gS' },
      },
    },
    {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup {
          auto_save = 'current',
        }
      end,
      cmd = {
        'NavigatorLeft',
        'NavigatorRight',
        'NavigatorUp',
        'NavigatorDown',
        'NavigatorPrevious',
      },
    },
    {
      'kevinhwang91/nvim-ufo',
      requires = 'kevinhwang91/promise-async',
      config = function()
        require 'plugins.configs.ufo'
      end,
    },
    {
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup()
        vim.keymap.set('n', '<BS>', function()
          require('fold-cycle').open()
        end)
      end,
    },
    {
      'mg979/vim-visual-multi',
      config = function()
        vim.g.VM_highlight_matches = 'underline'
        vim.g.VM_theme = 'nord'
        vim.g.VM_maps = {
          ['Find Under'] = '<C-e>',
          ['Find Subword Under'] = '<C-e>',
          ['Select Cursor Down'] = '\\j',
          ['Select Cursor Up'] = '\\k',
        }
      end,
    },
    {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup { enable = true }
      end,
    },
    {
      'psliwka/vim-dirtytalk',
      run = ':DirtytalkUpdate',
      config = function()
        vim.opt.spelllang:append 'programming'
      end,
    },
    {
      'saifulapm/chartoggle.nvim',
      config = function()
        require('chartoggle').setup {
          leader = '<localleader>', -- you can use any key as Leader
          keys = { ',', ';' }, -- Which keys will be toggle end of the line
        }
      end,
    },
  }
  --}}}

  --- Utilities {{{
  use {
    {
      'nvim-neorg/neorg',
      ft = 'norg',
      config = function()
        require 'plugins.configs.org'
      end,
    },
    {
      'kevinhwang91/nvim-hclipboard',
      event = 'BufRead',
      config = function()
        require('hclipboard').start()
      end,
    },
    {
      'danymat/neogen',
      cmd = 'Neogen',
      config = function()
        require('neogen').setup {
          snippet_engine = 'luasnip',
          enabled = true,
        }
      end,
    },
    {
      'ThePrimeagen/harpoon',
      after = 'plenary.nvim',
      config = function()
        require 'plugins.configs.harpoon'
      end,
    },
    { 'sQVe/sort.nvim', cmd = { 'Sort' } },
    {
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup {
          move_cursor = false,
          keymaps = {
            visual = 's',
          },
        }
      end,
    },
    {
      'kazhala/close-buffers.nvim',
      cmd = { 'BDelete' },
      config = function()
        require('close_buffers').setup {
          preserve_window_layout = { 'this', 'nameless' },
          next_buffer_cmd = function(windows)
            require('bufferline').cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()
            for _, window in ipairs(windows) do
              vim.api.nvim_win_set_buf(window, bufnr)
            end
          end,
        }
      end,
    },
  }
  --}}}

  -- Text Objects {{{
  use {
    { 'kana/vim-textobj-user' },
    {
      'kana/vim-textobj-indent',
      keys = { { 'x', 'ii' }, { 'o', 'ii' } },
    },
    {
      'phaazon/hop.nvim',
      keys = { { 'n', 's' }, 'f', 'F' },
      config = function()
        require 'plugins.configs.hop'
      end,
    },
    {
      'gbprod/substitute.nvim',
      keys = { { 'n', 'S' }, { 'n', 'X' }, { 'x', 'S' }, { 'x', 'X' } },
      config = function()
        require('substitute').setup()
        vim.keymap.set('n', 'S', function()
          require('substitute').operator()
        end)
        vim.keymap.set('x', 'S', function()
          require('substitute').visual()
        end)
        vim.keymap.set('n', 'X', function()
          require('substitute.exchange').operator()
        end)
        vim.keymap.set('x', 'X', function()
          require('substitute.exchange').visual()
        end)
        vim.keymap.set('n', 'Xc', function()
          require('substitute.exchange').cancel()
        end)
      end,
    },
  }
  -- }}}

  -- Operators {{{
  use {
    { 'kana/vim-operator-user' },
    {
      'kana/vim-operator-replace',
      keys = { { 'x', 'p' } },
      config = function()
        vim.keymap.set('x', 'p', '<Plug>(operator-replace)', { silent = true, noremap = false })
      end,
    },
  }
  -- }}}

  -- Testing and Debugging {{{
  use {
    {
      'vim-test/vim-test',
      cmd = { 'Test*' },
      keys = { '<localleader>tf', '<localleader>tn', '<localleader>ts' },
      config = function()
        vim.cmd [[
          function! FTermStrategy(cmd) abort
            call luaeval('vim.cmd("PackerLoad FTerm.nvim")')
            call luaeval("require('FTerm').run(_A[1])", [a:cmd])
          endfunction
          let g:test#custom_strategies = {'fterm': function('FTermStrategy')}
        ]]
        vim.g['test#strategy'] = 'fterm'
        vim.keymap.set('n', '<localleader>tf', '<cmd>TestFile<CR>')
        vim.keymap.set('n', '<localleader>tn', '<cmd>TestNearest<CR>')
        vim.keymap.set('n', '<localleader>ts', '<cmd>TestSuite<CR>')
      end,
    },
    {
      'mfussenegger/nvim-dap',
      module = 'dap',
      keys = { '<localleader>dc', '<localleader>db', '<localleader>dut ' },
      config = function()
        require 'plugins.configs.dap-config'
      end,
      require = {
        {
          'rcarriga/nvim-dap-ui',
          after = 'nvim-dap',
          config = function()
            local dapui = require 'dapui'
            dapui.setup()
            vim.keymap.set('n', '<localleader>duc', dapui.close)
            vim.keymap.set('n', '<localleader>dut', dapui.toggle)
            local nvim_dap = require 'dap'
            nvim_dap.listeners.before.event_terminated['dapui_config'] = function()
              dapui.close()
            end
            nvim_dap.listeners.before.event_exited['dapui_config'] = function()
              dapui.close()
            end
          end,
        },
        {
          'theHamsta/nvim-dap-virtual-text',
          after = 'nvim-dap',
          config = function()
            require('nvim-dap-virtual-text').setup()
          end,
        },
      },
    },
  }
  -- }}}

  --- Devs {{{
  use {
    { 'milisims/nvim-luaref' },
    { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
    { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  }
  --}}}

  -- Langs {{{
  use {
    { 'jwalton512/vim-blade' },
    { 'posva/vim-vue' },
  }
  -- }}}
end)
