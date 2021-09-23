local ultis = require("utils");
local packer = ultis.load_packer();

if not packer then
   return false
end

local use = packer.use
local use_rocks = packer.use_rocks

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

return packer.startup(function()

  use_rocks { 'penlight' }

  use { "nvim-lua/plenary.nvim" }
  use { "wbthomason/packer.nvim", event = "VimEnter" }
  use {
    "NvChad/nvim-base16.lua",
    after = "packer.nvim",
    config = function()
      require("theme").init()
    end,
  }

  use {
    "kyazdani42/nvim-web-devicons",
    after = "nvim-base16.lua",
    config = function()
      require("plugins.configs.icons")
    end,
  }

  use {
    "famiu/feline.nvim",
    after = "nvim-web-devicons",
    config = function()
      require("plugins.configs.statusline")
    end,
  }

  use {
    "akinsho/bufferline.nvim",
    after = "nvim-web-devicons",
    config = function()
      require("plugins.configs.bufferline")
    end,
    setup = function()
      require("core.mappings").bufferline()
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("plugins.configs.others").blankline()
    end,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    opt = true,
    ft = { 'html','css','sass' },
    cmd = {'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerReloadAllBuffers'},
    config = function()
      require("plugins.configs.others").colorizer()
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    branch = "0.5-compat",
    event = "BufRead",
    requires = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "0.5-compat",
        after = "nvim-treesitter",
      }
    },
    config = function()
      require "plugins.configs.treesitter"
    end,
  }

  use {
    'David-Kunz/treesitter-unit',
    event = "BufRead",
    setup = function()
      require("core.mappings").treesitter_unit()
    end,
  }

  -- git stuff
  use {
    "lewis6991/gitsigns.nvim",
    opt = true,
    config = function()
      require "plugins.configs.gitsigns"
    end,
    setup = function()
      require("utils").packer_lazy_load "gitsigns.nvim"
    end,
  }

  -- smooth scroll
  use {
    "karb94/neoscroll.nvim",
    opt = true,
    config = function()
      require("plugins.configs.others").neoscroll()
    end,
    setup = function()
      require("utils").packer_lazy_load "neoscroll.nvim"
    end,
  }

  -- lsp stuff
  use {
    "neovim/nvim-lspconfig",
    event = 'BufReadPre',
    config = function()
      require "plugins.configs.lspconfig"
    end,
  }

  use { 'folke/lua-dev.nvim' }

  use {
    "kabouzeid/nvim-lspinstall",
    module = "lspinstall",
    requires = "nvim-lspconfig",
    config = function()
      require("lspinstall").post_install_hook = function()
        require("plugins.configs.lspconfig").setup_servers()
        vim.cmd "bufdo e"
      end
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    run = function()
      require("utils").install('write-good', 'npm', 'install -g')
    end,
    event = 'User LspServersStarted',
    config = function()
      require("plugins.configs.others").null_ls()
    end,
  }

  use {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins.configs.others").signature()
    end,
  }

  use {
    'windwp/lsp-fastaction.nvim',
    config = function()
      require("plugins.configs.others").fastaction()
    end,
    setup = function()
      require("core.mappings").fastaction()
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    module = 'cmp',
    event = 'InsertEnter',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'f3fora/cmp-spell', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
    },
    config = function()
      require "plugins.configs.cmp"
    end,
  }

  use {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    module = 'luasnip',
    config = function()
      require "plugins.configs.luasnip"
    end,
  }

  use {
    "jdhao/better-escape.vim",
    event = "InsertEnter",
    setup = function()
      require("plugins.configs.others").better_escape()
    end,
  }

  -- file managing , picker etc
  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require "plugins.configs.nvimtree"
    end,
    setup = function()
      require("core.mappings").nvimtree()
    end,
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
         require("plugins.configs.others").autopairs()
    end
  }

  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope.*",
    requires = {
      {
        "sudormrfbin/cheatsheet.nvim",
        after = "telescope.nvim",
        -- because cheatsheet is not activated by a teleacope command
        module = "cheatsheet",
        config = function()
          require "plugins.configs.cheatsheet"
        end,
        setup = function()
          require("core.mappings").cheatsheet()
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        after = "telescope.nvim",
        run = "make",
      },
    },
    config = function()
      require "plugins.configs.telescope"
    end,
    setup = function()
      require("core.mappings").telescope()
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
    'b3nj5m1n/kommentary',
    event = 'BufReadPre',
    config = function()
      require("plugins.configs.others").comment()
    end,
  }

  use {
    'folke/todo-comments.nvim',
    config = function()
      require("plugins.configs.others").todo_comments()
    end,
    setup = function()
      require("core.mappings").todo_comments()
    end,
  }

  use {
    'phaazon/hop.nvim',
    cmd = {'HopChar1'},
    keys = { { 'n', 'f' }, { 'n', 'F' }, { 'o', 'f' }, { 'x', 'f' }, { 'o', 'F' }, { 'x', 'F' } },
    config = function()
      require("plugins.configs.others").hop()
    end,
    setup = function()
      require("core.mappings").hop()
    end,
  }

  -- Dev Plugins
  use { 'rafcamlet/nvim-luapad', cmd = 'Luapad' }
end)
