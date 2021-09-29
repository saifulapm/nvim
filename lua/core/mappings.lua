local utils = require 'utils'

local config = utils.load_config()
local map = utils.map

local maps = config.mappings
local plugin_maps = maps.plugin

local cmd = vim.cmd

local M = {}

-- these mappings will only be called during initialization
M.misc = function()
  local function non_config_mappings()
    -- Don't copy the replaced text after pasting in visual mode
    map('v', 'p', '"_dP')

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    map('', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map('', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    map('', '<Down>', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map('', '<Up>', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

    -- use ESC to turn off search highlighting
    map('n', '<Esc>', ':noh <CR>')

    -----------------------------------------------------------------------------//
    -- MACROS {{{
    -----------------------------------------------------------------------------//
    -- Absolutely fantastic function from stoeffel/.dotfiles which allows you to
    -- repeat macros across a visual range
    ------------------------------------------------------------------------------
    -- TODO: converting this to lua does not work for some obscure reason.
    vim.cmd [[
      function! ExecuteMacroOverVisualRange()
        echo "@".getcmdline()
        execute ":'<,'>normal @".nr2char(getchar())
      endfunction
    ]]

    map('x', '@', ':<C-u>call ExecuteMacroOverVisualRange()<CR>', { silent = false })
    --}}}

    ------------------------------------------------------------------------------
    -- Credit: JGunn Choi ?il | inner line
    ------------------------------------------------------------------------------
    -- includes newline
    map('x', 'al', '$o0')
    map('o', 'al', '<cmd>normal val<CR>')
    --No Spaces or CR
    map('x', 'il', [[<Esc>^vg_]])
    map('o', 'il', [[<cmd>normal! ^vg_<CR>]])

    -----------------------------------------------------------------------------//
    -- Add Empty space above and below
    -----------------------------------------------------------------------------//
    map('n', '[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
    map('n', ']<space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
    -----------------------------------------------------------------------------//
    -- search visual selection
    map('v', '//', [[y/<C-R>"<CR>]])

    -- Credit: Justinmk
    map('n', 'g>', [[<cmd>set nomore<bar>40messages<bar>set more<CR>]])
    -- Refocus folds
    map('n', '<localleader>z', [[zMzvzz]])
    -- Make zO recursively open whatever top level fold we're in, no matter where the
    -- cursor happens to be.
    map('n', 'zO', [[zCzO]])

    map('n', '<localleader>,', ":lua require('utils').toggle_char(',')<CR>")
    map('n', '<localleader>;', ":lua require('utils').toggle_char(';')<CR>")

    ------------------------------------------------------------------------------
    -- Buffers
    ------------------------------------------------------------------------------
    map('n', '<leader>on', [[<cmd>w <bar> %bd <bar> e#<CR>]])
    -- Use wildmenu to cycle tabs
    map('n', '<localleader><tab>', [[:b <Tab>]], { silent = false })
    -- Switch between the last two files
    map('n', '<leader><leader>', [[<c-^>]])

    -----------------------------------------------------------------------------//
    -- Capitalize
    -----------------------------------------------------------------------------//
    map('n', '<leader>U', 'gUiw`]')
    map('i', '<C-u>', '<cmd>norm!gUiw`]a<CR>')

    ----------------------------------------------------------------------------------
    -- Windows
    ----------------------------------------------------------------------------------
    -- Change two horizontally split windows to vertical splits
    map('n', '<localleader>wh', '<C-W>t <C-W>K')
    -- Change two vertically split windows to horizontal splits
    map('n', '<localleader>wv', '<C-W>t <C-W>H')
    -- equivalent to gf but opens the window in a vertical split
    -- vim doesn't have a native mapping for this as <C-w>f normally
    -- opens a horizontal split
    map('n', '<C-w>f', '<C-w>vgf')
    -- find visually selected text
    map('v', '*', [[y/<C-R>"<CR>]])
    -- make . work with visually selected lines
    map('v', '.', ':norm.<CR>')

    map('n', '<leader>qw', '<cmd>bd!<CR>')
    ----------------------------------------------------------------------------------
    -- Operators
    ----------------------------------------------------------------------------------
    -- Yank from the cursor to the end of the line, to be consistent with C and D.
    map('n', 'Y', 'y$')
    -----------------------------------------------------------------------------//
    -- Quick find/replace
    -----------------------------------------------------------------------------//
    local noisy = { silent = false }
    map('n', '<leader>[', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
    map('n', '<leader>]', [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
    map('v', '<leader>[', [["zy:%s/<C-r><C-o>"/]], noisy)
    -- Visual shifting (does not exit Visual mode)
    map('v', '<', '<gv')
    map('v', '>', '>gv')
    -- visually select the block of text I just pasted in Vim
    map('n', 'gV', '`[v`]')
    --Remap back tick for jumping to marks more quickly back
    map('n', "'", '`')

    --open a new file in the same directory
    map('n', '<leader>nf', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })
    --open a new file in the same directory
    map('n', '<leader>ns', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })

    -- Write and quit all files, ZZ is NOT equivalent to this
    map('n', 'qa', '<cmd>qa<CR>')

    ------------------------------------------------------------------------------
    -- Quickfix
    ------------------------------------------------------------------------------
    map('n', ']q', '<cmd>cnext<CR>zz')
    map('n', '[q', '<cmd>cprev<CR>zz')
    map('n', ']l', '<cmd>lnext<cr>zz')
    map('n', '[l', '<cmd>lprev<cr>zz')

    -------------------------------------------------------------------------------
    -- ?ie | entire object
    -------------------------------------------------------------------------------
    map('x', 'ie', [[gg0oG$]])
    map('o', 'ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])

    -- Zero should go to the first non-blank character not to the first column (which could be blank)
    -- but if already at the first character then jump to the beginning
    --@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
    map('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
    -- when going to the end of the line in visual mode ignore whitespace characters
    map('v', '$', 'g_')
    map(
      'n',
      'zz',
      [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
      { expr = true }
    )

    -----------------------------------------------------------------------------//
    -- Quotes
    -----------------------------------------------------------------------------//
    map('n', [[<leader>"]], [[ciw"<c-r>""<esc>]])
    map('n', '<leader>`', [[ciw`<c-r>"`<esc>]])
    map('n', "<leader>'", [[ciw'<c-r>"'<esc>]])
    map('n', '<leader>)', [[ciw(<c-r>")<esc>]])
    map('n', '<leader>}', [[ciw{<c-r>"}<esc>]])

    -- Map Q to replay q register
    map('n', 'Q', '@q')

    -----------------------------------------------------------------------------//
    -- Multiple Cursor Replacement
    -- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
    -----------------------------------------------------------------------------//
    map('n', 'cn', '*``cgn')
    map('n', 'cN', '*``cgN')

    -----------------------------------------------------------------------------//
    -- Command mode related
    -----------------------------------------------------------------------------//
    -- smooth searching, allow tabbing between search results similar to using <c-g>
    -- or <c-t> the main difference being tab is easier to hit and remapping those keys
    -- to these would swallow up a tab mapping
    -- Smart mappings on the command line
    map('c', 'w!!', [[w !sudo tee % >/dev/null]])
    -- insert path of current file into a command
    map('c', '%%', "<C-r>=fnameescape(expand('%'))<cr>")
    map('c', '::', "<C-r>=fnameescape(expand('%:p:h'))<cr>/")

    ----------------------------------------------------------------------------------
    -- Grep Operator
    ----------------------------------------------------------------------------------
    function gl.grep_operator(type)
      local saved_unnamed_register = vim.fn.getreg '@@'
      if type:match 'v' then
        vim.cmd [[normal! `<v`>y]]
      elseif type:match 'char' then
        vim.cmd [[normal! `[v`]y']]
      else
        return
      end
      -- Use Winnr to check if the cursor has moved it if has restore it
      local winnr = vim.fn.winnr()
      vim.cmd [[silent execute 'grep! ' . shellescape(@@) . ' .']]
      vim.fn.setreg('@@', saved_unnamed_register)
      if vim.fn.winnr() ~= winnr then
        vim.cmd [[wincmd p]]
      end
    end

    -- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
    map('n', '<leader>g', [[:silent! set operatorfunc=v:lua.gl.grep_operator<cr>g@]])
    map('x', '<leader>g', [[:call v:lua.gl.grep_operator(visualmode())<cr>]])

    ---------------------------------------------------------------------------------
    -- Toggle list
    ---------------------------------------------------------------------------------
    local function toggle_list(prefix)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local location_list = vim.fn.getloclist(0, { filewinid = 0 })
        local is_loc_list = location_list.filewinid > 0
        if vim.bo[buf].filetype == 'qf' or is_loc_list then
          vim.fn.execute(prefix .. 'close')
          return
        end
      end
      if prefix == 'l' and vim.tbl_isempty(vim.fn.getloclist(0)) then
        vim.notify('Location List is Empty.', 2)
        return
      end

      local winnr = vim.fn.winnr()
      vim.fn.execute(prefix .. 'open')
      if vim.fn.winnr() ~= winnr then
        vim.cmd [[wincmd p]]
      end
    end

    map('n', '<leader>ls', function()
      toggle_list 'c'
    end)
    map('n', '<leader>li', function()
      toggle_list 'l'
    end)

    gl.command { 'Todo', [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]] }
  end

  local function optional_mappings()
    -- don't yank text on cut ( x )
    if not config.options.copy_cut then
      map({ 'n', 'v' }, 'x', '"_x')
    end

    -- don't yank text on delete ( dd )
    if not config.options.copy_del then
      map({ 'n', 'v' }, 'dd', '"_dd')
    end

    -- navigation within insert mode
    if config.options.insert_nav then
      local inav = maps.insert_nav

      map('i', inav.backward, '<Left>')
      map('i', inav.end_of_line, '<End>')
      map('i', inav.forward, '<Right>')
      map('i', inav.next_line, '<Up>')
      map('i', inav.prev_line, '<Down>')
      map('i', inav.top_of_line, '<ESC>^i')
    end

    -- check the theme toggler
    if config.ui.theme_toggler.enabled then
      map(
        'n',
        maps.theme_toggler,
        ":lua require('utils').toggle_theme(require('utils').load_config().ui.theme_toggler.fav_themes) <CR>"
      )
      map('n', plugin_maps.telescope.themes, ":lua require('utils').theme_switcher()<CR>")
    end
  end

  local function required_mappings()
    map('n', maps.close_buffer, ":lua require('utils').close_buffer() <CR>") -- close  buffer
    map('n', maps.copy_whole_file, ':%y+ <CR>') -- copy whole file content
    map('n', maps.new_buffer, ':enew <CR>') -- new buffer
    map('n', maps.new_tab, ':tabnew <CR>') -- new tabs
    map('n', maps.save_file, ':w <CR>') -- ctrl + s to save file
    map('n', maps.reload_theme, ":lua require('utils').reload_theme()<CR>") -- ctrl + s to save file

    -- terminal mappings --
    local term_maps = maps.terminal
    -- get out of terminal mode
    map('t', term_maps.esc_termmode, '<C-\\><C-n>')
    -- hide a term from within terminal mode
    map(
      't',
      term_maps.esc_hide_termmode,
      "<C-\\><C-n> :lua require('core.utils').close_buffer() <CR>"
    )
    -- pick a hidden term
    map('n', term_maps.pick_term, ':Telescope terms <CR>')
    -- Open terminals
    -- TODO this opens on top of an existing vert/hori term, fixme
    map(
      'n',
      term_maps.new_horizontal,
      ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>"
    )
    map(
      'n',
      term_maps.new_vertical,
      ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>"
    )
    map(
      'n',
      term_maps.new_window,
      ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>"
    )
    -- terminal mappings end --

    -- Add Packer commands because we are not loading it at startup
    cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
    cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
    cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
    cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
    cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
    cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"

    -- add ChadReload command and maping
    -- cmd "silent! command! NvChadReload lua require('nvchad').reload_config()"
  end

  local function user_config_mappings()
    local custom_maps = config.custom.mappings or ''
    if type(custom_maps) ~= 'table' then
      return
    end

    for _, map_table in pairs(custom_maps) do
      map(unpack(map_table))
    end
  end

  non_config_mappings()
  optional_mappings()
  required_mappings()
  user_config_mappings()
end

-- below are all plugin related mappings

M.bufferline = function()
  local m = plugin_maps.bufferline

  map('n', m.next_buffer, ':BufferLineCycleNext <CR>')
  map('n', m.prev_buffer, ':BufferLineCyclePrev <CR>')
  map('n', '[b', '<Cmd>BufferLineMoveNext<CR>')
  map('n', ']b', '<Cmd>BufferLineMovePrev<CR>')
  map('n', m.moveLeft, '<C-w>h')
  map('n', m.moveRight, '<C-w>l')
  map('n', m.moveUp, '<C-w>k')
  map('n', m.moveDown, '<C-w>j')
  map('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>')
  map('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>')
  map('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>')
  map('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>')
  map('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>')
  map('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>')
  map('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>')
  map('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>')
  map('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>')
end

M.cheatsheet = function()
  local m = plugin_maps.cheatsheet

  map('n', m.default_keys, ":lua require('cheatsheet').show_cheatsheet_telescope() <CR>")
  map(
    'n',
    m.user_keys,
    ":lua require('cheatsheet').show_cheatsheet_telescope{bundled_cheatsheets = false, bundled_plugin_cheatsheets = false } <CR>"
  )
end

M.session = function()
  local m = plugin_maps.session
  map('n', m.session_load, ':RestoreSession<CR>')
  map('n', m.session_save, ':SaveSession<CR>')
end

M.nvimtree = function()
  map('n', plugin_maps.nvimtree.toggle, ':NvimTreeToggle <CR>')
  map('n', plugin_maps.nvimtree.focus, ':NvimTreeFocus <CR>')
end

M.truezen = function()
  local m = plugin_maps.truezen

  map('n', m.ataraxis_mode, ':TZAtaraxis <CR>')
  map('n', m.focus_mode, ':TZFocus <CR>')
  map('n', m.minimalistic_mode, ':TZMinimalist <CR>')
end

M.vim_fugitive = function()
  local m = plugin_maps.vim_fugitive

  map('n', m.git, ':Git <CR>')
  map('n', m.git_blame, ':Git blame <CR>')
  map('n', m.diff_get_2, ':diffget //2 <CR>')
  map('n', m.diff_get_3, ':diffget //3 <CR>')
end

M.treesitter_unit = function()
  map('x', 'iu', ':lua require"treesitter-unit".select()<CR>')
  map('x', 'au', ':lua require"treesitter-unit".select(true)<CR>')
  map('o', 'iu', '<Cmd>lua require"treesitter-unit".select()<CR>')
  map('o', 'au', '<Cmd>lua require"treesitter-unit".select(true)<CR>')
end

M.fastaction = function()
  map('n', '<leader>ca', ":lua require('lsp-fastaction').code_action()<CR>")
  map('x', '<leader>ca', "<esc><Cmd>lua require('lsp-fastaction').range_code_action()<CR>")
end

M.todo_comments = function()
  local m = plugin_maps.todo_comments
  map('n', m.toggle, '<Cmd>TodoTrouble<CR>')
end

M.hop = function()
  map('n', 'w', '<Cmd>HopChar1<CR>')
  map({ 'n', 'o', 'v' }, 'F', '<Cmd>HopWordBC<CR>')
  map({ 'n', 'o', 'v' }, 'f', '<Cmd>HopWordAC<CR>')
end

M.undotree = function()
  map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>')
end

return M
