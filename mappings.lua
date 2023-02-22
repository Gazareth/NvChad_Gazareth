local M = {}

M.disabled = {
  t = {
    ["<A-h>"] = { "", "toggle floating term" },
  },
  n = {
    ["<leader>fm"] = { "", "lsp formatting" },
    ["<leader>n"] = { "", "toggle line number" },
    ["<leader>rn"] = { "", "toggle relative number" },
    ["<C-n>"] = { "", "toggle nvimtree" },
    ["<leader>e"] = { "", "focus nvimtree" },
    ["<A-h>"] = { "", "toggle floating term" },
  },
}

-- Dashboard/Settings shortcuts
local switch_window = function(command)
  return function()
    vim.cmd("wincmd " .. command)
    local newFileType = vim.bo.filetype
    if newFileType == "NvimTree" then
      vim.cmd("wincmd " .. command)
    end
  end
end

local current_file_dir = function()
  return vim.fn.expand "%:p:h"
end

local explore_current_file_dir = function()
  if vim.g.is_windows then
    local escaped_file_path = current_file_dir():gsub("\\", "\\\\")
    local command = '!"explorer.exe \'' .. escaped_file_path .. "'\""
    vim.cmd(command)
  else
    vim.cmd("open " .. current_file_dir())
  end
end

local return_to_dashboard = function(set_cd)
  return function()
    vim.cmd "tabonly | enew | BufOnly"
    vim.cmd "Alpha"
    if set_cd then
      local current_type = vim.bo.filetype
      if current_type ~= "alpha" and #current_type ~= 0 then
        vim.cmd "CdHome"
      end
    end
    -- Exit current project
    require("projections.switcher"):set_current()
  end
end

M.general = {
  [{"n", "i"}] = {
    ["<C-Tab>"] = { "<cmd> tabnext <CR>", "Switch to next tab" },
    ["<C-S-Tab>"] = { "<cmd> tabprev <CR>", "Switch to previous tab" },
  },
  n = {
    -- Meta stuff
    ["<leader>ps"] = { "<cmd> PackerSync <CR>", "Sync packages" },
    ["<leader>cd"] = { "<cmd> :cd %:p:h <CR>", "Set directory to current file's" },
    ["<leader>ycd"] = {
      function()
        vim.fn.setreg("*", current_file_dir())
      end,
      "Yank current file directory to clipboard",
    },
    ["<leader>ecd"] = { explore_current_file_dir, "Open explorer at current file's directory (windows)" },

    -- Modes
    [";"] = { ":", "command mode", opts = { nowait = true } },

    ["ZW"] = { "<cmd> wa <CR>", "Save all files" },
    ["ZD"] = { return_to_dashboard(false), "Return to project dashboard" },
    ["ZDQ"] = { return_to_dashboard(true), "Return to dashboard" },
    ["ZA"] = { "<cmd> wa | qa <CR>", "Save all files then quit vim" },
    ["Zs"] = { "<cmd>so %<CR>", "Source current file" },

    -- Tab/window switching
    ["<C-w><C-v>"] = { "<cmd> vert sb # <CR>", "Open a vertical split of current and previous buffer" },
    ["<C-w><C-t>"] = { "<cmd> tabc <CR>", "Close tab" },
    ["<C-t>"] = { "<cmd> tabnew | Alpha <CR>", "Open new tab and run Alpha (dashboard)" },
    ["<TAB>"] = { switch_window "w", "Switch to next window" },
    ["<S-Tab>"] = { switch_window "W", "Switch to previous window" },

    -- Help with editing/writing text
    ["Y"] = { "^vg_", "select line (excluding EOL character)" },
    ["<leader><enter>"] = { ":call feedkeys('] [ i')<cr>", "Insert mode with new line above and below." },

    ["]d"] = { function() vim.diagnostic.goto_next() end, "Go to next diagnostic issue" },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, "Go to previous diagnostic issue" },
    -- Print out current mode on a delay (for debugging)
    -- ["<leader>m"] = { function()
    --   local timer = vim.loop.new_timer()
    --   local print_timer = vim.loop.new_timer()
    --   local curr_mode  = "n"
    --   timer:start(1000, 0, function ()
    --     curr_mode = vim.api.nvim_get_mode().mode
    --     print("Got mode!!!")
    --     print_timer:start(1000,0, function()
    --       print("Mode is: "..curr_mode)
    --       print_timer:stop()
    --       print_timer:close()
    --     end)
    --     timer:stop()
    --     timer:close()
    --   end)
    -- end
    -- ,
  },
  i = {
    ["="] = { " = ", "spaced equals" },
    [">="] = { " >= ", "spaced greater than or equal to" },
    ["<="] = { " <= ", "spaced less than or equal to" },
    ["=="] = { " == ", "spaced equality" },
    ["=>"] = { " => ", "spaced arrow operator" },
    ["{<space>"] = { "{  }<left><left>", "spaced curly braces" },
    ["[<space>"] = { "[  ]<left><left>", "spaced square braces" },
  },
  c = {},
  v = {
    ["<leader>/sa"] = { 'y:%s/<C-R>"//g<left><left>', "Replace selection on all lines." },
    ["<leader>/sc"] = { 'y:%s/<C-R>"//gc<left><left><left>', "Replace selection on all lines (with confirmation)." },
    ["<leader>/sl"] = { 'y:s/<C-R>"//g<left><left>', "Replace selection on current line." },
  },
  x = {
    ["il"] = { "g_o^", "Select inner line" },
  },
  o = {
    ["il"] = { "<cmd>:normal vil<CR>", "Text object: inner line" }
  }
}

M.leap = {
  [{ "n", "x", "o" }] = {
    ["-"] = { "<Plug>(leap-forward-to)", "Leap: forward-to" },
    ["+"] = { "<Plug>(leap-backward-to)", "Leap: backward-to" },
    ["gl"] = { "<Plug>(leap-cross-window)", "Leap: cross-window" },
  },
  [{"x", "o"}] = {
    ["g-"] = { "<Plug>(leap-forward-till)", "Leap: forward-till" },
    ["g+"] = { "<Plug>(leap-backward-till)", "Leap: backward-till" },
  }
}

M.leap_ast = {
  [{'n', 'x', 'o'}] =  { ["<A-n>"]  =  { function() require("leap-ast").leap() end, "Leap: AST node" }},
}

M.cellular_automation = {
  n = {
    ["<leader>fml"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "Make it rain (FML)" },
  },
}

M.focus = {
  n = {
    ["<F3>"] = { "<cmd> FocusMaximise <CR>", "Focus current window" },
  },
}

M.lspconfig = {
  n = {
    ["<leader>fmt"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },
  },
}

M.minimap = {
  n = {
    ["<leader>mm"] = { "<cmd> MinimapToggle <CR>", "Toggle code mini-map" }
  }
}

M.nvimtree = {
  n = {
    ["<leader>fd"] = {
      function()
        require("nvim-tree").toggle(false, true)
      end,
      "toggle nvimtree",
    },
    ["<leader>fe"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.tabufline = {
  n = {
    -- cycle through buffers
    ["<leader><TAB>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },
    ["<leader><S-Tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },
  },
}

M.telescope = {
  n = {
    ["<leader>fp"] = { "<cmd> Telescope projections <CR>", "find projects" },
    ["<leader><C-t>"] = { "<cmd> Telescope telescope-tabs list_tabs <CR>", "Browse tabs" },
    ["<leader>cdr"] = { "<cmd>Telescope cder<CR>", "Change current directory (cder)"}
  },
}

local tcpresent, tree_climber = pcall(require, "tree-climber")
if tcpresent then
  local tc_func = function(func_name, opts)
    return function() return tree_climber[func_name](opts) end
  end
  local tc_highlight = function(func_name) return tc_func(func_name, { highlight = true, skip_comments = true }) end
  local tc_skipcomments = function(func_name) return tc_func(func_name, { skip_comments = true }) end

  M.tree_climber = {
    [{"n", "v", "o"}] = {
      ["<A-k>"] = { tc_highlight("goto_parent"), "Go to parent Treesitter node" },
      ["<A-j>"] = { tc_highlight("goto_child"), "Go to child Treesitter node" },
      ["<A-l>"] = { tc_skipcomments("goto_next"), "Go to next Treesitter node" },
      ["<A-h>"] = { tc_skipcomments("goto_prev"), "Go to previous Treesitter node" },
    },
    [{"v", "o"}] = {
      ["ie"] = { tree_climber.select_node, "Select inside treesitter node" },
    },
    ["n"] = {
      ["<C-l>"] = { tree_climber.swap_next, "Swap with next Treesitter node" },
      ["<C-h>"] = { tree_climber.swap_prev, "Swap with previous Treesitter node" },
      ["<C-H>"] = { tree_climber.highlight_node, "Highlight Treesitter node" },
    }
  }
end

M.trouble = {
  n = {
    ["<leader>tc"] = { "<cmd> TroubleToggle <CR>", "Toggle Trouble (Diagnostics)" },
  },
}

-- M.wordmotion = {
--   [{"n", "x", "o"}] = {
--     ["<A-w>"] = {"<Plug>WordMotion_w", "WordMotion: Move 1 word forwards."},
--     ["<A-b>"] = {"<Plug>WordMotion_b", "WordMotion: Move 1 word backwards."},
--     ["<A-e>"] = {"<Plug>WordMotion_e", "WordMotion: Move to next end of word."},
--     ["<A-g><A-e>"] = {"<Plug>WordMotion_ge", "WordMotion:<C-S-T> Move to end of previous word."},
--   },
--   [{"x", "o"}] = {
--     ["<A-i><A-w>"] = { "<Plug>WordMotion_iw", "WordMotion: Inner word"},
--     ["<A-a><A-w>"] = { "<Plug>WordMotion_aw", "WordMotion: Around word"},
--   }
-- }

M.undoquit = {
  n = {
    ["<C-S-T>"] = { "<cmd> Undoquit <CR>", "Undo last quit window" },
  },
}

M.zen_mode = {
  n = {
    ["<S-F3>"] = { ":ZenMode <CR>", 'Toggle "Total Zen" mode' },
  },
}

return M
