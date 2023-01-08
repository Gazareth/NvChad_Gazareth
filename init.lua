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

  -- cmdheight = 20,
  -- cmdwinheight = 20,
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

-- Global command to set current directory to the nvim comfig dir
vim.api.nvim_create_user_command("CdHome", function()
  vim.cmd("cd "..vim.fn.stdpath('config'))
end, {})

-- GENERAL AUTOCMDS
-- Set cd to neovim config on start (if alpha is the only open buffer)
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local current_type = vim.bo.filetype
    local configPath = vim.fn.stdpath('config')
    if current_type == "alpha" or #current_type == 0 then
      vim.schedule(function() vim.cmd("CdHome") end)
    end
  end,
})

local bufCloseCandidates = {}

local isBufCloseCandidate = function(bi)
  if not vim.api.nvim_buf_is_valid(bi) then return 0 end
  local bn = vim.api.nvim_buf_get_name(bi)
  local line_count = vim.api.nvim_buf_line_count(bi)
  local bt = vim.bo[bi].filetype

  if (#bt == 0 and line_count == 1) or (#bn == 0 and bt == "alpha") then
    -- Candidate for closing.
    local bw = vim.fn.win_findbuf(bi)
    local bwe = vim.fn.empty(bw)
    if bwe == 1 then
      return 1
    elseif #bw == 1 then
      -- Buffer is not hidden... it is being shown on at least one window!
      -- But fear not! If these windows are the only ones in their tabs, we can close!
      for i,wid in ipairs(bw) do
        local tp = vim.api.nvim_win_get_tabpage(wid)
        local ws = vim.api.nvim_tabpage_list_wins(tp)
        if #ws == 1 then
          return 2
        end
      end
    end
  end
  return 0
end

local buf_clean = function()
  for _,bi in ipairs(bufCloseCandidates) do
    local c_score = isBufCloseCandidate(bi)
    if c_score > 0 then
      if c_score == 1 then 
        vim.cmd("bd "..bi)
        -- print("Closing "..bi)
      elseif c_score == 2 then
        local bw = vim.fn.win_findbuf(bi)
        if #bw == 1 then
          vim.api.nvim_win_close(bw[1], false)
          -- print("Closing window containing only "..bi)
        end
      end
    end
  end
end

local setupCloseBufCandidates = function()
  -- Get valid buffers
  local valid_bufs = vim.tbl_filter(function(bi)
    return vim.api.nvim_buf_is_valid(bi)
      and vim.api.nvim_buf_get_option(bi, 'buflisted')
  end, vim.api.nvim_list_bufs())

  local candidates = {}
  for _, bi in ipairs(valid_bufs) do
    if isBufCloseCandidate(bi) > 0 then
      table.insert(candidates, bi)
    else
    end
  end
  if #candidates > 0 then
    bufCloseCandidates = candidates
    vim.defer_fn(buf_clean, 2000)
  end
end

-- Close empty buffers when left
vim.api.nvim_create_autocmd({ "BufLeave" }, {
  callback = setupCloseBufCandidates
})

-- Highlight yanked text for a brief period after yanking
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "YankHighlight", timeout = 375 }
  end,
})


-- OPEN CONFIG FILES
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

  local open_fn = "tabnew"
  if vim.bo.filetype == "alpha" then
    open_fn = "e"
  end

  vim.cmd(open_fn.." "..left_full_path.." | vsp "..right_full_path)
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


