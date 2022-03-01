local map = require('utils').map
local hop = require 'hop'
hop.setup { keys = 'etovxqpdygfbzcisuran' }

map('n', 's', function()
  hop.hint_char1 { multi_windows = true }
end)

-- NOTE: override F/f using hop motions
map({ 'x', 'n' }, 'F', function()
  hop.hint_char1 {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    inclusive_jump = false,
  }
end)

map({ 'x', 'n' }, 'f', function()
  hop.hint_char1 {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
    inclusive_jump = false,
  }
end)

map('o', 'F', function()
  hop.hint_char1 {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    inclusive_jump = true,
  }
end)

map('o', 'f', function()
  hop.hint_char1 {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
    inclusive_jump = true,
  }
end)
