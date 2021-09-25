local present, dial = pcall(require, "dial")
if not present then
   return
end

local map = require("utils").map

dial.augends["custom#boolean"] = dial.common.enum_cyclic {
    name = "boolean",
    strlist = {"true", "false"},
}
table.insert(dial.config.searchlist.normal, "custom#boolean")

map({ 'n', 'v' }, '+', '<Plug>(dial-increment)', { noremap = false })
map({ 'n', 'v' }, '-', '<Plug>(dial-decrement)', { noremap = false })

