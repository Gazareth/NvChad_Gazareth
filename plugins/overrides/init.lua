local M = {}

M.alpha = require "custom.plugins.overrides.alpha"

M.blankline = {
  space_char_blankline = " ",
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  show_current_context = true,
  context_char = "┃",
  -- use_treesitter = true,
  -- use_treesitter_scope = true,
  space_char = "",
  filetype_exclude = {
    "NvimTree",
    "lspinfo",
    "packer",
    "checkhealth",
    "help",
    "man",
    "alpha",
    "",
  },
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
  remove_keymaps = { "<Tab>" },
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
    update_root = false,
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

local get_cder_opts = function()
  local HOME = os.getenv "HOME"

  local cder_opts = {
    prompt_title = function()
      return "cder [" .. HOME .. "]"
    end,
    previewer_command = table.concat {
      'EXA_COLORS="da=32"; exa ',
      "-a ",
      "--color=always ",
      "-T ",
      "--level=3 ",
      "--icons ",
      "--git-ignore ",
      "--long ",
      "--no-permissions ",
      "--no-user ",
      "--no-filesize ",
      "--git ",
      "--ignore-glob=.git",
    },
  }

  if vim.g.is_windows then
    local WSL_HOME = os.getenv "WSL_HOME"
    local wcder_opts = {
      entry_maker = function(line)
        return {
          value = line,
          display = function(entry)
            return " " .. line:gsub(HOME .. "\\", ""):gsub("\\", "/"), { { { 1, 3 }, "Directory" } }
          end,
          ordinal = line,
        }
      end,
      entry_value_fn = function(entry_value)
        local unix_path = entry_value:gsub("C:\\", "/mnt/c/"):gsub("\\", "/")
        return '"' .. unix_path .. '"'
      end,
    }

    cder_opts = vim.tbl_deep_extend("force", cder_opts, wcder_opts)
  end

  return cder_opts
end

M.telescope = function()
  local cder_opts = get_cder_opts()
  return {
    extensions = {
      cder = cder_opts,
    },
    defaults = {
      mappings = {
        n = {
          ["dd"] = function(pickerOpts)
            local actions = require "telescope.actions"
            actions.delete_buffer(pickerOpts)
          end,
        },
      },
    },
    -- extensions_list = { "themes", "terms", "projections" },
  }
end

M.ui = require "custom.plugins.overrides.ui"

return M
