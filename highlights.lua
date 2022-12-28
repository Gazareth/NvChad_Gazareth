-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

M.override = {
  CursorLine = {
    bg = "black2",
  },
  Comment = {
    italic = true,
  },

  St_NormalMode = {
    bg = "white",
  },
  St_InsertMode = {
    bg = "yellow",
  },
  St_TerminalMode = {
    bg = "blue",
  },
  St_NTerminalMode = {
    bg = "blue",
  },
  St_VisualMode = {
    bg = "dark_purple",
  },
  St_ReplaceMode = {
    bg = "orange",
  },
  St_ConfirmMode = {
    bg = "teal",
  },
  St_CommandMode = {
    bg = "red",
  },
  St_SelectMode = {
    bg = "dark_purple",
  },

  St_NormalModeSep = {
    fg = "white",
  },

  St_InsertModeSep = {
    fg = "yellow",
  },

  St_TerminalModeSep = {
    fg = "blue",
  },

  St_NTerminalModeSep = {
    fg = "blue",
  },

  St_VisualModeSep = {
    fg = "dark_purple",
  },

  St_ReplaceModeSep = {
    fg = "orange",
  },

  St_ConfirmModeSep = {
    fg = "teal",
  },

  St_CommandModeSep = {
    fg = "red",
  },

  St_SelectModeSep = {
    fg = "dark_purple",
  },
}

M.add = {
  NvimTreeOpenedFolderName = { fg = "blue", bold = true },
  NvimTreeOpenedFile = { fg = "teal", bold = true, italic = true },
  VisualMultiCursor = { fg = "grey_fg2", bg = "dark_purple" },
  InsertModeCursor = { fg = "black", bg = "sun" },
  VisualModeCursor = { fg = "black", bg = "dark_purple" },
  IndentBlanklineIndent1 = { fg  = "#E06C75" },
  IndentBlanklineIndent2 = { fg  = "#E5C07B" },
  IndentBlanklineIndent3 = { fg  = "#98C379" },
  IndentBlanklineIndent4 = { fg  = "#56B6C2" },
  IndentBlanklineIndent5 = { fg  = "#61AFEF" },
  IndentBlanklineIndent6 = { fg  = "#C678DD" },
}

return M
