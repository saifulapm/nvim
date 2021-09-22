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


end)
