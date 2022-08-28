local present, bufferline = pcall(require, "bufferline")

if not present then
  return
end

local options = {
  animation = false,
  tabpages = false,
  auto_hide = true,
}

bufferline.setup(options)
