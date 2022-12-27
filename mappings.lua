local M = {}

M.disabled = {
  n = {
    ["<leader>n"] = { "", "toggle line number" },
    ["<leader>rn"] = { "", "toggle relative number" },
  }
}

M.general = {
  n = {
    [";"] = { ":", "command mode", opts = { nowait = true } },
    ["<C-t>"] = { "<cmd> tabnew | Telescope find_files <CR>", "Open new tab and telescope find files" },
    ["<leader>ps"] = { "<cmd> PackerSync <CR>", "Sync packages"},
    ["ZA"] = { "<cmd> wa | qa <CR>", "Save all files then quit vim"},
    ["Y"] = { "0vg_", "select line (excluding EOL character)" },
    ["<leader><enter>"] = { ":call feedkeys('] [ i')<cr>", "Insert mode with new line above and below."},
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
    ["="] = { " = ", "spaced equals"},
    [">="] = { " >= ", "spaced greater than or equal to"},
    ["<="] = { " >= ", "spaced less than or equal to"},
    ["=="] = { " == ", "spaced equality"},
    ["=>"] = { " => ", "spaced arrow operator"},
    ["{<space>"] = { "{  }<left><left>", "spaced curly braces"},
  },
  c = {
  },
  v = {
    ["<leader>/sa"] = { 'y:%s/<C-R>"//g<left><left><left>', "Replace selection on all lines." },
    ["<leader>/sc"] = { 'y:%s/<C-R>"//gc<left><left><left>', "Replace selection on all lines (with confirmation)." },
    ["<leader>/sl"] = { 'y:s/<C-R>"//g<left><left><left>', "Replace selection on current line." },
  }
}

vim.g.camelcasemotion_key = '<leader>'

---- Leap keymaps ----
for _, _1_ in ipairs({{{"n", "x", "o"}, "-", "<Plug>(leap-forward-to)"}, {{"n", "x", "o"}, "_", "<Plug>(leap-backward-to)"}, {{"x", "o"}, "x", "<Plug>(leap-forward-till)"}, {{"x", "o"}, "X", "<Plug>(leap-backward-till)"}, {{"n", "x", "o"}, "gs", "<Plug>(leap-cross-window)"}}) do
  local _each_2_ = _1_
  local modes = _each_2_[1]
  local lhs = _each_2_[2]
  local rhs = _each_2_[3]
  for _0, mode in ipairs(modes) do
    if (force_3f or ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0))) then
      vim.keymap.set(mode, lhs, rhs, {silent = true})
    else
    end
  end
end

M.nvimtree = {
  n = {
    ["<leader>fd"] = { function()
      require'nvim-tree'.toggle(false,true)
    end, "toggle nvimtree" },
    ["<leader>fe"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  }
}

M.telescope = {
  n = {
    ["<leader>fp"] = { "<cmd> Telescope projections <CR>", "find projects" },
  }
}

return M
