-- local autocmd = vim.api.nvim_create_autocmd
require "custom.neovide"

local options  = {
  guicursor = "i:ver35-blinkwait1-blinkoff600-blinkon600-InsertModeCursor,v:block-blinkwait1-blinkoff200-blinkon1000-VisualModeCursor",

  relativenumber = true,

  backspace = "indent,eol,start",
  smarttab = true,

  showcmd = true,
  autowrite = true,
  autoread = true,

  hlsearch = false,
  incsearch = true,

  scrolloff = 1,
  sidescrolloff = 5,

  wrap = false,
  list = true,
  listchars = "tab:» ,extends:›,precedes:‹,nbsp:·,trail:·",
  -- opt.listchars:append "multispace:⋅"
  -- opt.listchars:append "eol:↴"
}

-- Set all options
for k,v in pairs(options) do
  vim.opt[k] = v
end

-- Is windows?
vim.g.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1

-- Set shell to powershell if on windowsM.path_separator = "/"
if vim.g.is_windows then
  vim.opt.shell = "powershell -NoLogo -ExecutionPolicy RemoteSigned"
end

-- Generic string split (courtesy of https://www.reddit.com/r/neovim/comments/su0em7/pathjoin_for_lua_or_vimscript_do_we_have_anything/)
local split = function(inputString, sep)
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

local getConfigFilePath = function(configRoot, relPath, pathSeparator)

  local configPathParts = split(configRoot, pathSeparator)
  local relPathParts = split(relPath, pathSeparator)

  local fullPathParts = {}

  for _, pathPart in ipairs(configPathParts) do
    table.insert(fullPathParts,pathPart)
  end

  for _, pathPart in ipairs(relPathParts) do
    table.insert(fullPathParts,pathPart)
  end

  return table.concat(fullPathParts, pathSeparator)
end

-- Set up a usercommand to open keyboard shortcuts
vim.api.nvim_create_user_command("EditKeyMappings", function()
  local pathSeparator = "/"
  if(vim.g.is_windows) then
    pathSeparator = "\\"
  end
  local configRoot = vim.api.nvim_command_output("echo stdpath('config')") -- Vim returns "/" on all OS's

  local coreMappingsPath = getConfigFilePath(configRoot, "lua\\core\\mappings.lua", pathSeparator)
  local customMappingsPath = getConfigFilePath(configRoot, "lua\\custom\\mappings.lua", pathSeparator)

  vim.cmd("tabnew "..coreMappingsPath.." | vsp "..customMappingsPath)
end, {})

-- Highlight yanked text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
   callback = function()
      vim.highlight.on_yank { higroup = "YankHighlight", timeout = 450 }
   end,
})

