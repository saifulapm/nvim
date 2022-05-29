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
      'NTBBloodbath/doom-one.nvim',
      config = function()
        require('doom-one').setup {
          pumblend = {
            enable = true,
            transparency_amount = 3,
          },
          cursor_coloring = true,
          italic_comments = true,
          plugins_integrations = {
            barbar = false,
            bufferline = true,
            telescope = true,
            neogit = false,
            dashboard = false,
            startify = false,
            whichkey = false,
            indent_blankline = true,
            vim_illuminate = true,
          },
        }
        -- Apply my own overwrite
        require('colors.doom').apply()
      end,
      setup = function()
        G.theme_loaded = true
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
        require('utils.color').overwrite { { 'FloatTitle', { inherit = 'Visual', bold = true } } }
        require('dressing').setup {
          input = {
            insert_only = false,
            winblend = 2,
            border = G.style.border.line,
          },
          select = {
            telescope = require('telescope.themes').get_cursor {
              layout_config = {
                -- NOTE: the limit is half the max lines because this is the cursor theme so
                -- unless the cursor is at the top or bottom it realistically most often will
                -- only have half the screen available
                height = function(self, _, max_lines)
                  local results = #self.finder.results
                  local PADDING = 4 -- this represents the size of the telescope window
                  local LIMIT = math.floor(max_lines / 2)
                  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
                end,
              },
            },
          },
        }
      end,
    },
    {
      'folke/todo-comments.nvim',
      disable = true,
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
    -- {
    --   'b0o/incline.nvim',
    --   config = function()
    --     require('incline').setup {
    --       hide = {
    --         focused_win = true,
    --       },
    --     }
    --   end,
    -- },
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
      },
      config = function()
        require 'plugins.lsp'
      end,
      requires = {
        { 'folke/lua-dev.nvim', opt = true },
        { 'hrsh7th/cmp-nvim-lsp', opt = true },
        { 'jose-elias-alvarez/null-ls.nvim', opt = true },
        { 'williamboman/nvim-lsp-installer', opt = true },
        { 'RRethy/vim-illuminate', opt = true },
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
        }
      end,
    },
    {
      'j-hui/fidget.nvim',
      after = 'nvim-lspconfig',
      config = function()
        require('fidget').setup {
          window = {
            blend = 0, -- BUG: window blend of > 0 interacts with nvim-bqf 😰
          },
        }
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
          check_ts = false,
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
    {
      'mattn/emmet-vim',
      cmd = 'EmmetInstall',
      setup = function()
        vim.g.user_emmet_complete_tag = 0
        vim.g.user_emmet_install_global = 0
        vim.g.user_emmet_install_command = 0
        vim.g.user_emmet_mode = 'i'
      end,
    },
  }
  -- }}}

  -- Telescope & Treesitter {{{
  use {
    {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<leader>fo', '<leader>ff', '<leader>fs', '<leader>fa', '<leader>fh' },
      module_pattern = 'telescope.*',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'fzf'
          end,
        },
      },
      config = function()
        require 'plugins.configs.telescope'
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      -- run = ':TSUpdate',
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
      'anuvyklack/pretty-fold.nvim',
      event = 'BufRead',
      config = function()
        require 'plugins.configs.prettyfold'
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
        require('utils.color').overwrite { { 'MarkSignHL', { foreground = 'Red' } } }
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
      event = 'BufRead',
      cmd = 'RestoreSession',
      config = function()
        require('auto-session').setup {
          log_level = 'error',
          auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
          auto_restore_enabled = false,
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
    -- TODO: this fixes a bug in neovim core that prevents "CursorHold" from working
    -- hopefully one day when this issue is fixed this can be removed
    -- @see: https://github.com/neovim/neovim/issues/12587
    {
      'antoinemadec/FixCursorHold.nvim',
      config = function()
        vim.g.curshold_updatime = 1000
      end,
    },
    {
      'andymass/vim-matchup',
      opt = true,
      setup = function()
        require('utils').lazy 'vim-matchup'
      end,
    },
    {
      'lewis6991/spaceless.nvim',
      event = 'InsertEnter',
      config = function()
        require('spaceless').setup()
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
  }
  --}}}

  --- Utilities {{{
  use {
    {
      'nvim-neorg/neorg',
      ft = 'norg',
      requires = { 'vhyrro/neorg-telescope', opt = true },
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
    -- {
    --   'SmiteshP/nvim-gps',
    --   after = 'nvim-treesitter',
    --   requires = 'nvim-treesitter',
    --   config = function()
    --     require('nvim-gps').setup()
    --   end,
    -- },
    {
      'ThePrimeagen/harpoon',
      after = 'plenary.nvim',
      config = function()
        require 'plugins.configs.harpoon'
      end,
    },
    {
      'sQVe/sort.nvim', -- Sort by line and delimiter.
      cmd = { 'Sort' },
      config = function()
        vim.cmd [[
          nnoremap <silent> go <Cmd>Sort<CR>
          nnoremap <silent> go" vi"<Esc><Cmd>Sort<CR>
          nnoremap <silent> go' vi'<Esc><Cmd>Sort<CR>
          nnoremap <silent> go( vi(<Esc><Cmd>Sort<CR>
          nnoremap <silent> go[ vi[<Esc><Cmd>Sort<CR>
          nnoremap <silent> gop vip<Esc><Cmd>Sort<CR>
          nnoremap <silent> go{ vi{<Esc><Cmd>Sort<CR>
          vnoremap <silent> go <Esc><Cmd>Sort<CR>
        ]]
      end,
      keys = { { 'n', 'go' }, { 'v', 'go' } },
    },
    { 'tpope/vim-surround' },
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
      'coderifous/textobj-word-column.vim',
      keys = { { 'x', 'ik' }, { 'x', 'ak' }, { 'o', 'ik' }, { 'o', 'ak' } },
      config = function()
        vim.g.skip_default_textobj_word_column_mappings = 1
        vim.keymap.set(
          'x',
          'ik',
          ':<C-u>call TextObjWordBasedColumn("aw")<CR>',
          { noremap = false }
        )
        vim.keymap.set(
          'x',
          'ak',
          ':<C-u>call TextObjWordBasedColumn("aw")<CR>',
          { noremap = false }
        )
        vim.keymap.set('o', 'ik', ':call TextObjWordBasedColumn("aw")<CR>', { noremap = false })
        vim.keymap.set('o', 'ak', ':call TextObjWordBasedColumn("aw")<CR>', { noremap = false })
      end,
    },
    {
      'kana/vim-textobj-indent',
      keys = { { 'x', 'ii' }, { 'o', 'ii' } },
    },
    {
      'gcmt/wildfire.vim',
      keys = { { 'n', '<CR>' } },
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
            -- NOTE: this opens dap UI automatically when dap starts
            -- dap.listeners.after.event_initialized['dapui_config'] = function()
            --   dapui.open()
            -- end
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
    -- { 'nanotee/luv-vimdocs' },
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
