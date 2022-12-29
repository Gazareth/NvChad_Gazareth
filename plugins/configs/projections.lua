local present, projections = pcall(require, "projections")

if not present then
  return
end

local options = {
  workspaces = {
    "X:\\Development\\Games\\Both",
    "C:\\Users\\Gareth\\AppData\\Local",
    "X:\\Development\\vim\\NvChad",
  },
  patterns = {
    ".git", ".svn", ".hg"
  },
  -- Close nvim-tree window on exit
  store_hooks = {
    pre = function()
      -- nvim-tree 
      local nvim_tree_present, api = pcall(require, "nvim-tree.api")
      if nvim_tree_present then api.tree.close() end

      -- neo-tree
      if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
    end
  },
  restore_hooks = {
    post = function()
      vim.cmd("cd " .. vim.loop.cwd())
    end
  }
}

require('telescope').load_extension('projections')

-- Create command to restore latest session
vim.api.nvim_create_user_command("RestoreLastProjectionsSession", function()
  local Session = require("projections.session")
  Session.restore_latest()
end, {})

-- Autostore session on VimExit
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  callback = function()
    local Session = require("projections.session")
    Session.store(vim.loop.cwd())
  end,
})

-- Switch to project if vim was started in a project dir
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local Switcher = require("projections.switcher")
    if vim.fn.argc() == 0 then Switcher.switch(vim.loop.cwd()) end
  end,
})

projections.setup(options)