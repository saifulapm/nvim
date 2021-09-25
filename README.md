<h1 align="center">Saiful's Neovim Config</h1>

## Features

- Lots of beautiful themes to choose from.
- Distraction free modes.
- Fast plugin loading. (55+ Plugins. Loaded 15-20ms (Depends on SSD))
- Smooth scrolling.
- Autosaving.
- File navigation with [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua).
- Managing tabs, buffers with [bufferline.nvim](https://github.com/akinsho/bufferline.nvim).
- Beautiful and configurable icons with [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons).
- Pretty and functional statusline with [feline.nvim](https://github.com/Famiu/feline.nvim).
- Git diffs and more with [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) .
- NeoVim Lsp configuration with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) and [lsp-isntalll](https://github.com/kabouzeid/nvim-lspinstall).
- Autocompletion with [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).
- File searching, previewing image and text files and more with [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).
- Syntax highlighting with [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
- Autoclosing braces and html tags with [nvim-autopairs](https://github.com/windwp/nvim-autopairs).
- Formatting code with [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim).
- Indentlines with [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim).
- Useful snippets with [LuaSnip](https://github.com/L3MON4D3/LuaSnip).
- Built in Theme Toggler and Theme Switter

# TODO

- Improving base plugins configurations
- Doc for All Mappings
- Adding more themes.

## How to Install this config

If you already have a ~/.config/nvim folder, make a backup with:

```
mv ~/.config/nvim ~/.config/NVIM.BAK
```

Then install this & it's plugins with:

```
git clone https://github.com/saifulapm/nvim ~/.config/nvim
nvim +PackerSync
```

Special Thanks to @NvChad and @akinsho
