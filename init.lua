-- local autocmd = vim.api.nvim_create_autocmd
local opt = vim.opt

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

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

require "custom.neovide"
