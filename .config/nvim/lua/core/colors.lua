-- ~/.config/nvim/lua/core/colors/lua
local glob = vim.g
local cmd = vim.cmd

local status, _ = pcall(cmd, "colorscheme sm")
if not status then
	print("Colorscheme not found, defaulting to builtin")
    cmd([[colorscheme desert]])
	return
end
