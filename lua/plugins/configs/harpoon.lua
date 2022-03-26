local map = require('utils').map
local mappings = require('core.keymaps').mappings.plugins.harpoon
local u = require 'utils.color'

u.overwrite {
  -- { 'HarpoonWindow', { link = 'NormalFloat' } },
  { 'HarpoonBorder', { foreground = u.get_hl('NonText', 'fg') } },
}
require('harpoon').setup {
  menu = {
    borderchars = G.style.border.chars,
  },
}
map('n', mappings.add, '<cmd>lua require("harpoon.mark").add_file()<CR>')
map('n', mappings.toggle, '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>')
map('n', mappings.next, '<cmd>lua require("harpoon.ui").nav_next()<CR>')
map('n', mappings.prev, '<cmd>lua require("harpoon.ui").nav_prev()<CR>')
map('n', '<localleader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>')
map('n', '<localleader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>')
map('n', '<localleader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>')
map('n', '<localleader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<CR>')
map('n', '<localleader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<CR>')
