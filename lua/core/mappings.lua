-- My Keymaps
local map = require('utils').map
local mappings = require('core.keymaps').mappings
local M = {}

M.basic = function()
  -- Basic Mapping
  map('n', '\\', ',')
  map({ 'n', 'x', 'o' }, 'H', '^')
  map({ 'n', 'x', 'o' }, 'L', '$')
  -- map('n', '<CR>', ':', { silent = false })
  map('n', '<C-h>', '<CMD>NavigatorLeft<CR>')
  map('n', '<C-l>', '<CMD>NavigatorRight<CR>')
  map('n', '<C-k>', '<CMD>NavigatorUp<CR>')
  map('n', '<C-j>', '<CMD>NavigatorDown<CR>')
  map('n', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
  map('n', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
  map('n', '<Down>', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
  map('n', '<Up>', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
  map('n', mappings.misc.no_highlight, ':nohl<CR>')
  -- map({ 'n', 'x', 'o' }, mappings.misc.go_to_matching, '%', { noremap = false })
  map('n', mappings.misc.line_number_toggle, ':set nu! <CR>') -- toggle numbers
  map('n', mappings.misc.relative_line_number_toggle, ':set rnu! <CR>') -- toggle relative numbers
  map('n', '<Leader>ps', ':PackerStatus<CR>')

  --
  -- -- required_mappings
  -- map('n', mappings.misc.copy_whole_file, ':%y+ <CR>') -- copy whole file content
  map('n', mappings.misc.new_buffer, ':enew <CR>') -- new buffer
  map('n', mappings.misc.new_tab, ':tabnew <CR>') -- new tabs
  map('n', mappings.misc.save_file, ':w <CR>')
  map('n', 'S408', ':w! <CR>') -- <cmd+s>
  --
  -- -- Insert Mode Mapping
  -- map('i', mappings.insert_nav.backward, '<Left>')
  -- map('i', mappings.insert_nav.forward, '<Right>')
  -- map('i', mappings.insert_nav.prev_line, '<Up>')
  -- map('i', mappings.insert_nav.next_line, '<Down>')
  map('i', mappings.insert_nav.beginning_of_line, '<ESC>^i')
  map('i', mappings.insert_nav.end_of_line, '<End>')
  map('i', mappings.insert_nav.delete_by_word, '<C-[>diwa')
  map('i', mappings.insert_nav.delete, '<Del>')
  map('i', mappings.insert_nav.delete_by_line, '<C-G>u<C-U>')
  map('i', mappings.insert_nav.save, '<Esc>:w<CR>')
  map('i', 'S408', '<Esc>:w<CR>') --<cmd+s>

  -- Complete curly brackets using K&R style
  map('i', mappings.insert_nav.curly_brackets, '<Esc>A {<cr>}<Esc>O')

  -- Terminal
  map('n', mappings.terminal.toggle_terminal, function()
    if not packer_plugins['FTerm.nvim'].loaded then
      vim.cmd [[PackerLoad FTerm.nvim]]
    end
    require('FTerm').toggle()
  end)
  map('t', mappings.terminal.toggle_terminal, '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

  --
  -- -- Commandline Mapping
  map('c', mappings.command_nav.backward, '<Left>', { silent = false })
  map('c', mappings.command_nav.forward, '<Right>', { silent = false })
  map('c', mappings.command_nav.beginning_of_line, '<Home>', { silent = false })
  map('c', mappings.command_nav.end_of_line, '<End>', { silent = false })
  map('c', mappings.command_nav.delete, '<Del>', { silent = false })
  map(
    'c',
    mappings.command_nav.expand_directory,
    [[<C-R>=expand("%:p:h") . "/" <CR>]],
    { silent = false }
  )
  --
  -- -- MACROS
  map(
    'x',
    mappings.visual_mode_mappings.macros_on_selected_area,
    ":lua require('utils').visual_macro()<CR>",
    { silent = false }
  )

  -- -- search visual selection
  map('x', mappings.visual_mode_mappings.search_on_selected_area, [[y/<C-R>"<CR>]])

  -- -- Credit: Justinmk
  map('n', mappings.misc.recent_40_messages, [[<cmd>set nomore<bar>40messages<bar>set more<CR>]])
  -- -- Refocus folds
  map('n', mappings.misc.refocus_fold, [[zMzvzz]])
  -- -- Make zO recursively open whatever top level fold we're in, no matter where the
  -- -- cursor happens to be.
  map('n', mappings.misc.open_all_folds, [[zCzO]])
  --
  -- -- Add Empty space above and below
  map('n', mappings.misc.blank_line_above, [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
  map('n', mappings.misc.blank_line_below, [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
  --
  -- -- ToggleChar
  map(
    'n',
    mappings.plugins.toggle_character.toggle_comma,
    ":lua require('utils').toggle_char(',')<CR>"
  )
  map(
    'n',
    mappings.plugins.toggle_character.toggle_semicolon,
    ":lua require('utils').toggle_char(';')<CR>"
  )

  -- -- Move
  map('n', mappings.misc.line_move_down, '<cmd>move+<CR>==')
  map('n', mappings.misc.line_move_up, '<cmd>move-2<CR>==')
  map('x', mappings.visual_mode_mappings.line_move_up, ":move-2<CR>='[gv")
  map('x', mappings.visual_mode_mappings.line_move_down, ":move'>+<CR>='[gv")

  --
  -- -- Buffer
  map('n', mappings.misc.delete_other_buffers, ':BDelete other<CR>')
  map('n', mappings.misc.toggle_last_file, '<C-^>')
  map('n', mappings.misc.close_buffer, ':BDelete this<CR>')
  map('n', mappings.misc.clear_all_buffers, ':BDelete all<CR>')
  map('n', 'gb', ':BufferLinePick<CR>')
  map('n', mappings.misc.scratch_buffer, ':lua require("utils").scratch()<CR>')
  map('n', mappings.plugins.bufferline.next_buffer, ':BufferLineCycleNext <CR>')
  map('n', mappings.plugins.bufferline.prev_buffer, ':BufferLineCyclePrev <CR>')
  map('n', '<A-Tab>', ':BufferLineCycleNext <CR>') -- S402 map to <C-tab>. check kitty config
  map('n', mappings.plugins.bufferline.move_buffer_next, ':BufferLineMoveNext <CR>')
  map('n', mappings.plugins.bufferline.move_buffer_prev, ':BufferLineMovePrev <CR>')
  map('n', mappings.plugins.bufferline.pick_buffer, ':BufferLinePick <CR>')
  map('n', mappings.plugins.bufferline.pick_close, ':BufferLinePickClose <CR>')
  map('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>')
  map('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>')
  map('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>')
  map('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>')
  map('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>')
  map('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>')
  map('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>')
  map('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>')
  map('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>')

  -- -- Session
  map('n', mappings.plugins.session.restore_session, ':RestoreSession<CR>')
  map('n', mappings.plugins.session.save_session, ':SaveSession<CR>')

  -- Cheatsheet
  map(
    'n',
    mappings.misc.cheatsheet,
    ":lua require('utils.cheatsheet').show(require('core.keymaps').mappings)<CR>"
  )

  -- This line opens my plugins file in a vertical split
  map(
    'n',
    '<leader>ep',
    string.format('<Cmd>vsplit %s/lua/plugins/init.lua<CR>', vim.fn.stdpath 'config')
  )

  -- Windows
  -- Change two horizontally split windows to vertical splits
  map('n', '<localleader>wh', '<C-W>t <C-W>K')
  -- Change two vertically split windows to horizontal splits
  map('n', '<localleader>wv', '<C-W>t <C-W>H')
  -- equivalent to gf but opens the window in a vertical split
  -- vim doesn't have a native mapping for this as <C-w>f normally
  -- opens a horizontal split
  map('n', '<C-w>f', '<C-w>vgf')
  map('n', '<leader>qw', '<cmd>bd!<CR>')

  map('n', 'Y', 'y$')
  map('x', '<', '<gv')
  map('x', '>', '>gv')
  -- visually select the block of text I just pasted in Vim
  map('n', 'gV', '`[v`]')
  --Remap back tick for jumping to marks more quickly back
  map('n', "'", '`')

  -- Quick find/replace
  map('n', '<leader>[', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false })
  map('n', '<leader>]', [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false })
  map('x', '<leader>[', [["zy:%s/<C-r><C-o>"/]], { silent = false })

  --open a new file in the same directory
  map('n', '<leader>nf', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })
  --open a new file in the same directory
  map('n', '<leader>ns', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })

  -- Quickfix
  map('n', ']q', '<cmd>cnext<CR>zz')
  map('n', '[q', '<cmd>cprev<CR>zz')
  map('n', ']l', '<cmd>lnext<cr>zz')
  map('n', '[l', '<cmd>lprev<cr>zz')

  -- ?ie | entire object
  map('x', 'ie', [[gg0oG$]])
  map('o', 'ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])

  -- Zero should go to the first non-blank character
  map(
    { 'n', 'x', 'o' },
    '0',
    "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
    { expr = true }
  )
  -- when going to the end of the line in visual mode ignore whitespace characters
  map({ 'n', 'x' }, '$', 'g_')

  -- Toggle top/center/bottom
  map(
    'n',
    'zz',
    [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
    { expr = true }
  )

  -- Quotes
  map('n', [[<leader>"]], [[ciw"<c-r>""<esc>]])
  map('n', '<leader>`', [[ciw`<c-r>"`<esc>]])
  map('n', "<leader>'", [[ciw'<c-r>"'<esc>]])
  map('n', '<leader>)', [[ciw(<c-r>")<esc>]])
  map('n', '<leader>}', [[ciw{<c-r>"}<esc>]])

  -- Open plugin directly to github
  map('n', 'gf', function()
    ---@diagnostic disable-next-line: missing-parameter
    local repo = vim.fn.expand '<cfile>'
    if not repo or #vim.split(repo, '/') ~= 2 then
      return vim.cmd 'norm! gf'
    end
    local url = string.format('https://www.github.com/%s', repo)
    vim.fn.jobstart('open ' .. url)
    vim.notify(string.format('Opening %s at %s', repo, url))
  end)

  -- Map Q to replay q register
  map('n', 'Q', '@q')

  -- Multiple Cursor Replacement
  map({ 'n', 'x' }, 'cn', '*``cgn')
  map({ 'n', 'x' }, 'cN', '*``cgN')
end

M.lspconfig = function(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { buffer = bufnr })
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr })
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = bufnr })
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = bufnr })
  map('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { buffer = bufnr })
  map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { buffer = bufnr })
  map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { buffer = bufnr })
  map(
    'n',
    '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    { buffer = bufnr }
  )
  map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { buffer = bufnr })
  map('n', '<leader>ra', '<cmd>lua vim.lsp.buf.rename()<CR>', { buffer = bufnr })
  map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { buffer = bufnr })
  map('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = bufnr })
  map('n', '[d', function()
    vim.diagnostic.goto_prev {
      float = {
        border = G.style.border.line,
        focusable = false,
        source = 'always',
      },
    }
  end, { buffer = bufnr })
  map('n', ']d', function()
    vim.diagnostic.goto_next {
      float = {
        border = G.style.border.line,
        focusable = false,
        source = 'always',
      },
    }
  end, { buffer = bufnr })
  map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { buffer = bufnr })
  -- map('n', '<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>', { buffer = bufnr })

  if client.supports_method 'textDocument/formatting' then
    vim.cmd [[
        augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePost <buffer> silent! lua require('utils.lsp').formatting(vim.fn.expand("<abuf>"))
        augroup END
        ]]
  end
  map('n', 'S404', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
end

M.nvimtree = function()
  map('n', '<C-n>', ':NvimTreeToggle <CR>')
  map('n', '<C-f>', ':NvimTreeFocus <CR>')
  map('n', 'S401', ':NvimTreeToggle <CR>') -- <Cmd+1>
end

return M
