-- local autocmd = vim.api.nvim_create_autocmd
require "custom.neovide"

local opt = vim.opt

opt.guicursor = "i:ver35-blinkwait1-blinkoff600-blinkon600-InsertModeCursor,v:block-blinkwait1-blinkoff200-blinkon1000-VisualModeCursor"

opt.relativenumber = true

opt.backspace  =  '2'
opt.showcmd = true
opt.autowrite = true
opt.autoread = true

opt.hlsearch = false
opt.incsearch = true

opt.wrap = false

opt.list = true
opt.listchars:append "multispace:⋅"
-- opt.listchars:append "eol:↴"

-- Set shell to powershell if on windows
if vim.fn.has('windows') then
  opt.shell = "powershell -NoLogo -ExecutionPolicy RemoteSigned"
end

