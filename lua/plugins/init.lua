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
        }
        -- Apply my own overwrite
        require('colors.doom').apply()
      end,
      setup = function()
        G.theme_loaded = true
      end,
    },
    {
      'kyazdani42/nvim-web-devicons',
      config = function()
        require 'plugins.configs.icons'
      end,
    },
    {
      'numToStr/Comment.nvim',
      event = 'BufRead',
      config = function()
        require('Comment').setup()
      end,
    },
  }
  -- }}}

  -- UI Plugin {{{
  use {
    {
      'akinsho/bufferline.nvim',
      event = 'BufAdd',
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
      config = function()
        require('dressing').setup {
          input = {
            insert_only = false,
          },
          select = {
            telescope = {
              theme = 'cursor',
            },
          },
        }
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
  }
  -- }}}

  --- LSP Staff {{{
  use {
    {
      'neovim/nvim-lspconfig',
      ft = { 'lua', 'php', 'liquid' },
      config = function()
        require 'plugins.lsp'
      end,
      requires = {
        { 'folke/lua-dev.nvim' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'jose-elias-alvarez/null-ls.nvim' },
        { 'b0o/schemastore.nvim' },
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
          handler_opts = { border = 'rounded' },
        }
      end,
    },
    {
      'j-hui/fidget.nvim',
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
  }
  -- }}}

  --- Completion {{{
  use {
    {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      branch = 'dev',
      event = { 'InsertEnter' },
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
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ''
        vim.g.copilot_filetypes = {
          ['*'] = false,
          gitcommit = false,
          NeogitCommitMessage = false,
          dart = true,
          lua = true,
          php = true,
          javascript = true,
        }
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
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
        {
          'camgraff/telescope-tmux.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'tmux'
          end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'smart_history'
          end,
        },
        {
          'nvim-telescope/telescope-github.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'gh'
          end,
        },
      },
      config = function()
        require 'plugins.configs.telescope'
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require 'plugins.configs.treesitter'
      end,
      requires = {
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'p00f/nvim-ts-rainbow' },
      },
    },
    { 'mrjones2014/dash.nvim', run = 'make install', after = 'telescope.nvim' },
  }
  -- }}}

  --- Editor Helper {{{
  use {
    {
      'kyazdani42/nvim-tree.lua',
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
          border = 'single',
          dimensions = {
            height = 0.6,
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
  }
  --}}}

  -- Text Objects {{{
  use {
    { 'kana/vim-textobj-user' },
    {
      'coderifous/textobj-word-column.vim',
      keys = { { 'x', 'ik' }, { 'x', 'ak' }, { 'o', 'ik' }, { 'o', 'ak' } },
      setup = function()
        vim.g.skip_default_textobj_word_column_mappings = 1
        vim.keymap.set('x', 'ik', ':<C-u>call TextObjWordBasedColumn("aw")<CR>', { silent = false })
        vim.keymap.set('x', 'ak', ':<C-u>call TextObjWordBasedColumn("aw")<CR>', { silent = false })
        vim.keymap.set('o', 'ik', ':call TextObjWordBasedColumn("aw")<CR>', { silent = false })
        vim.keymap.set('o', 'ak', ':call TextObjWordBasedColumn("aw")<CR>', { silent = false })
      end,
    },
    {
      'kana/vim-textobj-indent',
      keys = { { 'x', 'ii' }, { 'o', 'ii' } },
    },
    {
      'gcmt/wildfire.vim',
      keys = { { 'n', '<CR>' }, { 'n', '<BS' } },
    },
    {
      'phaazon/hop.nvim',
      keys = { { 'n', 's' }, 'f', 'F' },
      config = function()
        require 'plugins.configs.hop'
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

  --- Devs {{{
  use {
    -- { 'nanotee/luv-vimdocs' },
    { 'milisims/nvim-luaref' },
    { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
  }
  --}}}
end)
