local M = {}

-- Path to overriding theme and highlights files
local themes = require "custom.overidden_themes"
local highlights = require "custom.highlights"

M.ui = {
  theme_toggle = { "onedark", "one_light" },
  theme = "monokai-pro",
  changed_themes = themes,
  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = require "custom.plugins"

-- require('telescope').load_extension('projects')
-- require'telescope'.extensions.projects.projects{}

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
