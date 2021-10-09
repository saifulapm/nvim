local ultis = require 'utils'
local packer = ultis.load_packer()

if not packer then
  return false
end

local use = packer.use
local use_rocks = packer.use_rocks

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

return packer.startup(function()
  use_rocks { 'penlight' }

  use { 'nvim-lua/plenary.nvim' }
  use { 'wbthomason/packer.nvim', event = 'VimEnter' }
  use {
    'NvChad/nvim-base16.lua',
    after = 'packer.nvim',
    config = function()
      require('theme').init()
    end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    after = 'nvim-base16.lua',
    config = function()
      require 'plugins.configs.icons'
    end,
  }

  use {
    'akinsho/bufferline.nvim',
    after = 'nvim-web-devicons',
    config = function()
      require 'plugins.configs.bufferline'
    end,
    setup = function()
      require('core.mappings').bufferline()
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = function()
      require('plugins.configs.others').blankline()
    end,
  }

  use {
    'norcalli/nvim-colorizer.lua',
    opt = true,
    ft = { 'html', 'css', 'sass' },
    cmd = {
      'ColorizerToggle',
      'ColorizerAttachToBuffer',
      'ColorizerDetachFromBuffer',
      'ColorizerReloadAllBuffers',
    },
    config = function()
      require('plugins.configs.others').colorizer()
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    event = 'BufRead',
    requires = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = '0.5-compat',
        after = 'nvim-treesitter',
      },
    },
    config = function()
      require 'plugins.configs.treesitter'
    end,
  }

  use {
    'David-Kunz/treesitter-unit',
    event = 'BufRead',
    setup = function()
      require('core.mappings').treesitter_unit()
    end,
  }

  -- git stuff
  use {
    'lewis6991/gitsigns.nvim',
    opt = true,
    config = function()
      require 'plugins.configs.gitsigns'
    end,
    setup = function()
      require('utils').packer_lazy_load 'gitsigns.nvim'
    end,
  }

  use {
    'nathom/filetype.nvim',
    config = function()
      require('filetype').setup {
        overrides = {
          literal = {
            ['kitty.conf'] = 'kitty',
          },
        },
      }
    end,
  }

  -- smooth scroll
  use {
    'karb94/neoscroll.nvim',
    opt = true,
    config = function()
      require('plugins.configs.others').neoscroll()
    end,
    setup = function()
      require('utils').packer_lazy_load 'neoscroll.nvim'
    end,
  }

  -- lsp stuff
  use {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      require 'plugins.configs.lspconfig'
    end,
  }

  use { 'folke/lua-dev.nvim' }

  use {
    'kabouzeid/nvim-lspinstall',
    module = 'lspinstall',
    requires = 'nvim-lspconfig',
    config = function()
      require('lspinstall').post_install_hook = function()
        require('plugins.configs.lspconfig').setup_servers()
        vim.cmd 'bufdo e'
      end
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    run = function()
      require('utils').install('write-good', 'npm', 'install -g')
      require('utils').install('prettier', 'npm', 'install -g')
    end,
    event = 'User LspServersStarted',
    config = function()
      require('plugins.configs.others').null_ls()
    end,
  }

  use {
    'ray-x/lsp_signature.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('plugins.configs.others').signature()
    end,
  }

  use {
    'windwp/lsp-fastaction.nvim',
    config = function()
      require('plugins.configs.others').fastaction()
    end,
    setup = function()
      require('core.mappings').fastaction()
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    module = 'cmp',
    event = 'InsertEnter',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
    },
    config = function()
      require 'plugins.configs.cmp'
    end,
  }

  use {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    module = 'luasnip',
    config = function()
      require 'plugins.configs.luasnip'
    end,
  }

  use {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function()
      require('plugins.configs.others').better_escape()
    end,
  }

  -- file managing , picker etc
  use {
    'kyazdani42/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    config = function()
      require 'plugins.configs.nvimtree'
    end,
    setup = function()
      require('core.mappings').nvimtree()
    end,
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('plugins.configs.others').autopairs()
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = { '<leader>fo', '<leader>ff', '<leader>fs', '<leader>fw' },
    module = 'telescope.*',
    requires = {
      {
        'sudormrfbin/cheatsheet.nvim',
        after = 'telescope.nvim',
        -- because cheatsheet is not activated by a teleacope command
        module = 'cheatsheet',
        config = function()
          require 'plugins.configs.cheatsheet'
        end,
        setup = function()
          require('core.mappings').cheatsheet()
        end,
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        after = 'telescope.nvim',
        run = 'make',
        config = function()
          require('telescope').load_extension 'fzf'
        end,
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        after = 'telescope.nvim',
        requires = 'tami5/sqlite.lua',
        config = function()
          require('telescope').load_extension 'frecency'
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
        'camgraff/telescope-tmux.nvim',
        after = 'telescope.nvim',
        config = function()
          require('telescope').load_extension 'tmux'
        end,
      },
    },
    config = function()
      require 'plugins.configs.telescope'
    end,
  }

  use {
    'gelguy/wilder.nvim',
    event = { 'CursorHold', 'CmdlineEnter' },
    rocks = { 'luarocks-fetch-gitrec', 'pcre2' },
    requires = { 'romgrk/fzy-lua-native' },
    config = function()
      gl.source('vimscript/wilder.vim', true)
    end,
  }

  use {
    'numToStr/Comment.nvim',
    event = 'BufReadPre',
    config = function()
      require('plugins.configs.others').comment()
    end,
  }

  use {
    'folke/todo-comments.nvim',
    config = function()
      require('plugins.configs.others').todo_comments()
    end,
    setup = function()
      require('core.mappings').todo_comments()
    end,
  }

  use {
    'phaazon/hop.nvim',
    cmd = { 'HopChar1', 'HopWordAC', 'HopWordBC' },
    config = function()
      require('plugins.configs.others').hop()
    end,
    setup = function()
      require('core.mappings').hop()
    end,
  }

  use {
    'rmagatti/auto-session',
    cmd = { 'RestoreSession', 'SaveSession' },
    config = function()
      require('plugins.configs.others').session()
    end,
    setup = function()
      require('core.mappings').session()
    end,
  }

  use {
    'AckslD/nvim-neoclip.lua',
    config = function()
      require('plugins.configs.others').neoclip()
    end,
  }

  -- Quickfix
  use {
    'kevinhwang91/nvim-bqf',
  }

  use {
    'https://gitlab.com/yorickpeterse/nvim-pqf',
    event = 'VimEnter',
    config = function()
      require('pqf').setup()
    end,
  }

  use {
    'kevinhwang91/nvim-hclipboard',
    event = 'InsertCharPre',
    config = function()
      require('hclipboard').start()
    end,
  }

  use { 'arecarn/vim-fold-cycle' }

  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    setup = function()
      require('core.mappings').undotree()
    end,
    config = function()
      vim.g.undotree_TreeNodeShape = '◉' -- Alternative: '◦'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  }

  -- Use <Tab> to escape from pairs such as ""|''|() etc.
  use {
    'abecodes/tabout.nvim',
    wants = { 'nvim-treesitter' },
    after = { 'nvim-cmp' },
    config = function()
      require('tabout').setup {
        completion = false,
        ignore_beginning = false,
      }
    end,
  }

  use {
    'monaqa/dial.nvim',
    keys = { { 'n', '-' }, { 'n', '+' }, { 'v', '-' }, { 'v', '+' } },
    config = function()
      require 'plugins.configs.dial'
    end,
  }

  use {
    'svermeulen/vim-subversive',
    event = 'BufReadPre',
    config = function()
      require('plugins.configs.others').subversive()
    end,
  }

  use { 'dart-lang/dart-vim-plugin', ft = 'dart' }
  use { 'plasticboy/vim-markdown', ft = 'markdown' }
  use { 'mtdl9/vim-log-highlighting' }
  -- use { 'fladson/vim-kitty' }
  use {
    'haya14busa/vim-asterisk',
    event = 'BufReadPre',
    config = function()
      require('plugins.configs.others').asterisk()
    end,
  }

  use {
    'vhyrro/neorg',
    ft = 'norg',
    branch = 'unstable',
    requires = { 'vhyrro/neorg-telescope' },
    config = function()
      require 'plugins.configs.neorg'
    end,
  }

  use {
    'kristijanhusak/orgmode.nvim',
    ft = { 'org' },
    -- TODO: Need to setup Mapping
    config = function()
      require 'plugins.configs.orgmode'
    end,
  }
  --------------------------------------------------------------------------------
  -- TPOPE {{{1
  --------------------------------------------------------------------------------
  use 'tpope/vim-repeat'
  -- sets searchable path for filetypes like go so 'gf' works
  use { 'tpope/vim-apathy', ft = { 'go', 'python', 'javascript', 'typescript' } }
  -- TODO: surround, abolish, eunuch, sleuth, projectionist

  -- Dev Plugins
  use { 'rafcamlet/nvim-luapad', cmd = 'Luapad' }
  use { 'nanotee/luv-vimdocs' }
  use { 'milisims/nvim-luaref' }
end)
