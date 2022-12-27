local M = {}

M.alpha = require "custom.plugins.alpha"

M.blankline = {
  space_char_blankline = " ",
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  show_current_context = true,
  context_char = '┃',
  -- use_treesitter = true,
  -- use_treesitter_scope = true,
  space_char = "",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "typescript",
    "c",
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
  },
}

-- nvimtree
M.nvimtree = {
  open_on_setup = true,
  ignore_buffer_on_setup = true,
  hijack_unnamed_buffer_when_opening = true,
  git = {
    enable = true,
    ignore = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.telescope = {
  defaults = {
    mappings = {
      n = {
        ["dd"] = function(pickerOpts)
          local actions = require('telescope.actions')
          actions.delete_buffer(pickerOpts)
      end,
      },
    },
  },
  -- extensions_list = { "themes", "terms", "projections" },
}

return M
