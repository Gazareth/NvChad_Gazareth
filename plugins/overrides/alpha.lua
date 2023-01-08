local present, alpha = pcall(require, "alpha")

-- This is copied from NvChad's plugins/configs/alpha.lua
-- It's a function that creates buttons for alpha-nvim
local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ""
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

-- Disable statusline in dashboard
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    -- store initial statusline value to be used later
    if type(vim.g.nvchad_vim_laststatus) == "nil" then
      vim.g.nvchad_vim_laststatus = vim.opt.laststatus._value
    end

    -- Remove statusline since we have just loaded into an "alpha" filetype (i.e. dashboard)
    vim.opt.laststatus = 0

    vim.api.nvim_create_autocmd({ "TabEnter", "BufLeave" }, {
      callback = function()
        local current_type = vim.bo.filetype
        if current_type == "alpha" or #current_type == 0 then
          -- Switched to alpha or unknown filetype
          vim.opt.laststatus = 0
        else
          -- Switched to any other filetype
          vim.opt.laststatus = vim.g.nvchad_vim_laststatus
        end
      end
    })

  end,
})

return {
  headerPaddingBottom = { type = "padding", val = 4 },
  buttons = {
    type = "group",
    val = {
      button("SPC f s", "  Load Previous Session", ":RestoreLastProjectionsSession <CR>"),
      button("SPC f p", "  Open Project", ":Telescope projections<CR>"),
      button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
      button("SPC t e", "  Terminal  ", ":terminal <CR>"),
      -- button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
      -- button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
      -- button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
      button("SPC t h", "  Themes  ", ":Telescope themes<CR>"),
      -- button("SPC e s", "⌨  Keyboard Mappings", ":e stdpath('config') . '/custom/mappings.lua' | :noautocmd lcd %:p:h <CR>"),
      button("SPC t k", "  Command Lookup", ":Telescope keymaps <CR>"),

      button("SPC e k", "  Keyboard Mappings", ":EditKeyMappings <CR>"),
      button("SPC e o", "  Set Options", ":EditCustomOptions <CR>"),
      button("SPC e d", "舘 Configure Dashboard", ":EditCustomDashboard <CR>"),
      button("SPC e p", "  Configure Plugins", ":EditInstalledPlugins <CR>"),
      button("SPC p s", "  Sync packages", ":PackerSync <CR>"),
      button("SPC e s", "  Settings", ":e $MYVIMRC | :noautocmd lcd %:p:h <CR>"),
      button("q", "  Quit Neovim", ":qa <CR>"),
    },
    opts = {
      spacing = 1,
    },
  },
}

