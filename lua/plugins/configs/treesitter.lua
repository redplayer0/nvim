local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
  return
end

local options = {
  ensure_installed = {
    "lua",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
}

treesitter.setup(options)
