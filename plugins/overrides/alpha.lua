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

return {
  headerPaddingBottom = { type = "padding", val = 4 },
  buttons = {
    type = "group",
    val = {
      button("SPC f s", "  Load Previous Session", ":RestoreLastProjectionsSession <CR>"),
      button("SPC f p", "  Open Project", ":Telescope projections<CR>"),
      button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
      -- button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
      -- button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
      -- button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
      button("SPC t h", "  Themes  ", ":Telescope themes<CR>"),
      -- button("SPC e s", "⌨  Keyboard Mappings", ":e stdpath('config') . '/custom/mappings.lua' | :noautocmd lcd %:p:h <CR>"),
      button("SPC e k", "  Keyboard Mappings", ":EditKeyMappings <CR>"),
      button("SPC t k", "  Command Lookup", ":Telescope keymaps <CR>"),

      button("SPC e o", "  Set Options", ":EditCustomOptions <CR>"),
      button("SPC e p", "  Configure Plugins", ":EditInstalledPlugins <CR>"),
      button("SPC p s", "  Sync packages", ":PackerSync <CR>"),
      button("SPC e s", "  Settings", ":e $MYVIMRC | :noautocmd lcd %:p:h <CR>"),
    },
    opts = {
      spacing = 1,
    },
  },
}

