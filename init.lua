-- local autocmd = vim.api.nvim_create_autocmd
require "custom.neovide"

local final_opts = {}
local options  = {
  guicursor = "i:ver35-blinkwait1-blinkoff600-blinkon600-InsertModeCursor,v:block-blinkwait1-blinkoff200-blinkon1000-VisualModeCursor",

  autoindent = true,
  relativenumber = true,

  backspace = "indent,eol,start",
  smarttab = true,

  showcmd = true,
  autowrite = true,
  autoread = true,

  incsearch = true,
  inccommand = "nosplit",

  scrolloff = 1,
  sidescrolloff = 5,

  wrap = false,
  list = true,
  listchars = "tab:» ,extends:►,precedes:◄,nbsp:·,trail:▒,",
  -- opt.listchars:append "multispace:⋅"
  -- opt.listchars:append "eol:↴"
}


-- Is windows?
vim.g.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1

-- Set shell to bash or powershell
if vim.g.is_windows then
  local woptions = {}

  -- USE BASH! (WSL)
  if true then
    woptions = { shell = "bash" }
  else
    woptions = {
      shell = "powershell",
      shellquote = "shellpipe=| shellxquote=",
      shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned",
      shellredir = "| Out-File -Encoding UTF8",
    }
  end
  final_opts = vim.tbl_extend("force", options, woptions)
end

-- Set all options
for k,v in pairs(final_opts) do
  vim.opt[k] = v
end

-- Highlight yanked text for a brief period after yanking
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "YankHighlight", timeout = 375 }
  end,
})

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

local getOSConfig = function()
  local pathSeparator = "/"
  if(vim.g.is_windows) then
    pathSeparator = "\\"
  end
  local configRoot = vim.fn.stdpath('config')
  return { pathSeparator = pathSeparator, configRoot = configRoot }
end

local open_config_files = function(left_rel_path, right_rel_path)
  local OSCfg = getOSConfig()
  local left_full_path = getConfigFilePath(OSCfg.configRoot, left_rel_path, OSCfg.pathSeparator)
  local right_full_path = getConfigFilePath(OSCfg.configRoot, right_rel_path, OSCfg.pathSeparator)

  vim.cmd("tabnew "..left_full_path.." | vsp "..right_full_path)
end

local config_commands = {
  ["EditCustomDashboard"] = {
    "lua\\plugins\\configs\\alpha.lua", "lua\\custom\\plugins\\overrides\\alpha.lua"
  },
  ["EditKeyMappings"] = {
    "lua\\core\\mappings.lua", "lua\\custom\\mappings.lua"
  },
  ["EditInstalledPlugins"] = {
    "lua\\plugins\\init.lua", "lua\\custom\\plugins\\init.lua"
  },
  ["EditCustomOptions"] = {
    "lua\\core\\options.lua", "lua\\custom\\init.lua"
  },
}

-- Create commands for above configs
for k,v in pairs(config_commands) do
  vim.api.nvim_create_user_command(k, function()
    open_config_files(v[1], v[2])
  end, {})
end


