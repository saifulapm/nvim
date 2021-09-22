local M = {}

-- load config
-- 1st arg = boolean - whether to force reload
-- Modifies _G._NVCHAD_CONFIG global variable
M.load_config = function(reload)
  if _G._MAIN_CONFIG ~= nil and not (reload or false) then
    return _G._MAIN_CONFIG
  end

  local main_config = "config"
  local config_file = vim.fn.stdpath "config" .. "/lua/" .. main_config .. ".lua"
  -- unload the modules if force reload
  if reload then
    package.loaded[main_config or false] = nil
  end

  _G._MAIN_CONFIG = require(main_config)
  return _G._MAIN_CONFIG
end

M.map = function(mode, keys, cmd, opt)
   local options = { noremap = true, silent = true }
   if opt then
      options = vim.tbl_extend("force", options, opt)
   end

   -- all valid modes allowed for mappings
   -- :h map-modes
   local valid_modes = {
      [""] = true,
      ["n"] = true,
      ["v"] = true,
      ["s"] = true,
      ["x"] = true,
      ["o"] = true,
      ["!"] = true,
      ["i"] = true,
      ["l"] = true,
      ["c"] = true,
      ["t"] = true,
   }

   -- helper function for M.map
   -- can gives multiple modes and keys
   local function map_wrapper(mode, lhs, rhs, options)
      if type(lhs) == "table" then
         for _, key in ipairs(lhs) do
            map_wrapper(mode, key, rhs, options)
         end
      else
         if type(mode) == "table" then
            for _, m in ipairs(mode) do
               map_wrapper(m, lhs, rhs, options)
            end
         else
            if valid_modes[mode] and lhs and rhs then
               vim.api.nvim_set_keymap(mode, lhs, rhs, options)
            else
               mode, lhs, rhs = mode or "", lhs or "", rhs or ""
               print("Cannot set mapping [ mode = '" .. mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]")
            end
         end
      end
   end

   map_wrapper(mode, keys, cmd, options)
end

M.load_packer = function()
  local present, packer = pcall(require, "packer")

  if not present then
    local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

    print "Cloning packer.."
    -- remove the dir before cloning
    vim.fn.delete(packer_path, "rf")
    vim.fn.system {
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      "--depth",
      "20",
      packer_path,
    }

    vim.cmd "packadd packer.nvim"

    present, packer = pcall(require, "packer")

    if present then
      print "Packer cloned successfully."
    else
      error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
    end
  else
    vim.cmd "packadd packer.nvim"
  end

  -- HACK: see https://github.com/wbthomason/packer.nvim/issues/180
  vim.fn.setenv('MACOSX_DEPLOYMENT_TARGET', '10.15')

  packer.init {
    max_jobs = 20,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 600, -- Timeout, in seconds, for git clones
    },
    auto_clean = true,
    compile_on_sync = true,
  }
  return packer
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
   if plugin then
      timer = timer or 0
      vim.defer_fn(function()
         require("packer").loader(plugin)
      end, timer)
   end
end

return M
