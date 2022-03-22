local cmd = vim.cmd

cmd 'packadd packer.nvim'

local present, packer = pcall(require, 'packer')

if not present then
  local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

  print 'Cloning packer..'
  -- remove the dir before cloning
  vim.fn.delete(packer_path, 'rf')
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    '--depth',
    '20',
    packer_path,
  }

  cmd 'packadd packer.nvim'
  present, packer = pcall(require, 'packer')

  if present then
    print 'Packer cloned successfully.'
  else
    error("Couldn't clone packer !\nPacker path: " .. packer_path .. '\n' .. packer)
  end
end

packer.init {
  max_jobs = 20,
  display = {
    prompt_border = G.style.border.line,
    open_cmd = 'silent topleft 65vnew',
  },
  git = {
    clone_timeout = 800, -- Timeout, in seconds, for git clones
  },
  auto_clean = true,
  compile_on_sync = true,
  auto_reload_compiled = true,
  compile_path = vim.fn.stdpath 'config' .. '/lua/_compiled.lua',
}

return packer
