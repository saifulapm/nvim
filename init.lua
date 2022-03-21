local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

local core_modules = {
  'core',
  'core.options',
  'core.autocmds',
  -- 'core.statusline',
}

for _, module in ipairs(core_modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error('Error loading ' .. module .. '\n\n' .. err)
  end
end

-- Load keybindings module at the end because the keybindings module cost is high
vim.defer_fn(function()
  require('core.mappings').basic()
end, 20)
