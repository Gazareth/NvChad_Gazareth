local present, modicator = pcall(require, "modicator")

if not present then
  return
end

local options = {
  show_warnings = true, -- Show warning if any required option is missing
  highlights = {
    modes = {
      ['i'] = require("modicator").get_highlight_fg('St_InsertModeSep'),
      ['c'] = require("modicator").get_highlight_fg('St_CommandModeSep'),
      ['v'] = require("modicator").get_highlight_fg('St_VisualModeSep'),
      ['V'] = require("modicator").get_highlight_fg('St_VisualModeSep'),
      [''] = require("modicator").get_highlight_fg('St_VisualModeSep'),
      ['s'] = require("modicator").get_highlight_fg('St_VisualModeSep'),
      ['S'] = require("modicator").get_highlight_fg('St_VisualModeSep'),
      ['R'] = require("modicator").get_highlight_fg('St_ReplaceModeSep'),
      ['t'] = require("modicator").get_highlight_fg('St_TerminalModeSep'),
    },
  },
}

modicator.setup(options)
