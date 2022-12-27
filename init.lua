-- local autocmd = vim.api.nvim_create_autocmd
require "custom.neovide"

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

if vim.fn.has('windows') then -- Use PowerShell Core
  -- opt.shell = "powershell.exe -NoLogo shellpipe=| shellxquote="
  opt.shell = "powershell -NoLogo -ExecutionPolicy RemoteSigned"
  -- opt.shellcmdflag = ""
  -- set shellredir=\|\ Out-File\ -Encoding\ UTF8
end
-- opt.shell = "powershell shellquote=( shellpipe=\\| shellredir=> shellxquote="
-- opt.shellcmdflag = "-NoLogo\\ -NoProfile\\ -ExecutionPolicy\\ RemoteSigned\\ -Command"

