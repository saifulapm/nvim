local present, icons = pcall(require, 'nvim-web-devicons')
if not present then
  return
end

local colors = G.style.doom

icons.setup {
  override = {
    default = {
      icon = '',
      color = colors.teal,
      name = 'Default',
    },
  },
}
