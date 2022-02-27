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
      'jose-elias-alvarez/buftabline.nvim',
      event = 'BufAdd',
      config = function()
        require 'plugins.configs.buftabline'
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
  }
  -- }}}

  --- LSP Staff {{{
  use {
    {
      'neovim/nvim-lspconfig',
      ft = { 'lua', 'php' },
      config = function()
        require 'plugins.lsp'
      end,
      requires = {
        { 'folke/lua-dev.nvim' },
        { 'hrsh7th/cmp-nvim-lsp' },
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
      -- module = 'cmp',
      -- event = { 'InsertEnter', 'CmdlineEnter' },
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
      -- cmd = 'EmmetInstall',
      -- setup = function()
      --   vim.g.user_emmet_complete_tag = 0
      --   vim.g.user_emmet_install_global = 0
      --   vim.g.user_emmet_install_command = 0
      --   vim.g.user_emmet_mode = 'i'
      -- end,
    }
  }
  -- }}}

  -- Telescope & Treesitter {{{
  use {
    {
      'nvim-telescope/telescope.nvim',
      module = 'telescope',
      cmd = 'Telescope',
      config = function()
        require 'plugins.configs.telescope'
      end,
      setup = function()
        require('core.mappings').telescope()
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
  }
  --}}}

  --- Devs {{{
  use {
    -- { 'nanotee/luv-vimdocs' },
    { 'milisims/nvim-luaref' },
    { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
  }
  --}}}
end)
