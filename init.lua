-- Saifulapm Neovim Config --

-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

local init_modules = {
   "core",
   "core.options",
}

for _, module in ipairs(init_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      vim.notify("Error loading " .. module .. "\n\n" .. err)
   end
end

-- Load keybindings module at the end because the keybindings module cost is high
vim.defer_fn(function()
  require("core.mappings").misc()
end, 20)
P(vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)))
