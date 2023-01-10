local overrides = require "custom.plugins.overrides"

local project_name_display = function()
  local projections_available, Session = pcall(require, "projections.session")
  if projections_available then
    local info = Session.info(vim.loop.cwd())
    if info ~= nil then
      -- local session_file_path = tostring(info.path)
      -- local project_workspace_patterns = info.project.workspace.patterns
      -- local project_workspace_path = tostring(info.project.workspace)
      -- local project_path = vim.fn.pathshorten(info.project.workspace.path.path, 3)
      local project_path = info.project.workspace.path.path
      return project_path
    end
  end
  return vim.fs.basename(vim.loop.cwd())
end

return {

  -- OVERRIDES --
  ["NvChad/base46"] = {
    config = function()
      local ok, base46 = pcall(require, "base46")

      if ok then
        base46.load_theme()
        local theme = base46.get_theme_tb("base_16")

        for i = 0, 15, 1 do
          vim.g["terminal_color_"..i] = theme[string.format("base%02X", i)]
        end
      end

    end
  },

  ["NvChad/ui"] = {
    override_options = {
      statusline = {
        overriden_modules = function()
          -- Common stuff
          local sep_style = vim.g.statusline_sep_style
          local separators = (type(sep_style) == "table" and sep_style) or require("nvchad_ui.icons").statusline_separators[sep_style]
          local sep_l = separators["left"]
          local sep_r = separators["right"]
          local fn = vim.fn
          -- FILENAME
          local fileicon = " "
          local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"
          local foldername = filename and fn.expand("%:.:h"):gsub("\\", "/")

          if filename ~= "Empty" then
            local devicons_present, devicons = pcall(require, "nvim-web-devicons")

            if devicons_present then
              local ft_icon = devicons.get_icon(filename)
              fileicon = (ft_icon ~= nil and ft_icon) or ""
            end

            filename = " " .. filename .. " "
          end

          local file_name = fileicon .. filename
          local folder_info = " " .. foldername
          local file_path_seps = "%%#St_folder_chevs#" .. "  " .. "%%#St_file_folder_info#"
          folder_info = folder_info:gsub("/", file_path_seps)
          local folder_portion = "%#St_file_folder_info#" .. folder_info .. " " .. "%#St_folder_sep#" .. sep_r
          local file_portion = "%#St_file_info#" .. file_name .. "%#St_file_sep#" .. sep_r .. "%#St_file_git_sep#" .. sep_r
          local file_info = folder_portion .. file_portion

          -- CWD
          local project_indicator = ""
          local project_name = project_name_display()
          if #project_name then
            project_indicator = "%#St_cwd_project#" .. "["..project_name .. "] "
          end

          local dir_icon = "%#St_cwd_icon#" .. " "
          local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

          local cwd_expr = (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name .. project_indicator)) or ""

          -- LSP
          local lsp_status = "   LSP "
          if rawget(vim, "lsp") then
            for _, client in ipairs(vim.lsp.get_active_clients()) do
              if client.attached_buffers[vim.api.nvim_get_current_buf()] then
                local enough_cols = vim.o.columns > 1
                local lsp_prefix = "   LSP: "
                local lsp_client = client.name
                lsp_status = (enough_cols and "%#St_LspStatus#" .. lsp_prefix .. "%#St_LspAttachedName#" .. lsp_client .. " ") or lsp_status
              end
            end
          end

          return {
            fileInfo = function() return file_info end,
            LSP_status = function() return lsp_status end,
            cwd = function() return cwd_expr end,
          }
        end,
      },
    },
  },

  ["lewis6991/gitsigns.nvim"] = {
    rm_default_opts = true,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    rm_default_opts = true,
    after = "plenary.nvim",
    config = function()
      require "plugins.configs.telescope"
    end,
    setup = function()
      require("core.utils").load_mappings "telescope"
    end,
    override_options = overrides.telescope
  },

  ["goolord/alpha-nvim"] = {
    disable = false,
    override_options = overrides.alpha,
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.overrides.lspconfig"
    end,
  },

  ["folke/which-key.nvim"] = {
    disable = false,
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = overrides.treesitter,
  },

  ["lukas-reineke/indent-blankline.nvim"] = {
    override_options = overrides.blankline,
  },

  ["williamboman/mason.nvim"] = {
    override_options = overrides.mason,
  },

  ["kyazdani42/nvim-tree.lua"] = {
    override_options = overrides.nvimtree,
  },
  -- OVERRIDES END --

  ["nathom/filetype.nvim"] = {},

  ["mbbill/undotree"] = {},
  ["Asheq/close-buffers.vim"] = {},
  ["gnikdroy/projections.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require "custom.plugins.configs.projections"
    end
  },

  ["zane-/cder.nvim"] = {
    cmd = "Telescope cder",
    after = "telescope.nvim",
    config = function()
      require('telescope').load_extension('cder')
    end
  },

  ["LukasPietzschmann/telescope-tabs"] = {
    requires = { "nvim-telescope/telescope.nvim" },
    after = "telescope.nvim",
    config = function()
      require'telescope-tabs'.setup{
        close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
        close_tab_shortcut_n = 'dd',     -- if you're in normal mode
      }
    end
  },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require('telescope').load_extension('ui-select')
    end
  },

  -- Multi-coloured indent indicators
  ["mawkler/modicator.nvim"] = {
    after = "base46",
    config = function()
      require "custom.plugins.configs.modicator"
    end,
  },

  ["yuttie/comfortable-motion.vim"] = {
    config = function()
      require "custom.plugins.configs.comfortable-motion"
    end
  },

  ["folke/zen-mode.nvim"] = {
    config = function()
      require("zen-mode").setup {
        window = {
          width = .75
        }
      }
    end
  },

  -- ["shortcuts/no-neck-pain.nvim"] = {},
  ["folke/twilight.nvim"] = {},

  -- ["roman/golden-ratio"] = {
  --   config = function()
  --     vim.g.golden_ratio_exclude_nonmodifiable = 1
  --   end
  -- },
  ["beauwilliams/focus.nvim"] = {
    config = function() require("focus").setup() end
  },

  ["numToStr/BufOnly.nvim"] = {
    cmd = "BufOnly"
  },

  ["AndrewRadev/undoquit.vim"] = {
    config = function()
      vim.g.undoquit_mapping = ""
      vim.g.undoquit_tab_mapping = ""
    end
  },

  ["folke/lsp-colors.nvim"] = {},

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  ["ofirgall/open.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("open").setup()
      vim.keymap.set('n', 'gx', require('open').open_cword)
    end,
  },

  ["gbprod/substitute.nvim"] = {
    config = function()
      require("substitute").setup()
      -- Lua
      vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { desc = "Substitute (With motion)" ,noremap = true })
      vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { desc = "Substitute (Line)" ,noremap = true })
      vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { desc = "Substitute (To end of line)" ,noremap = true })
      vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { desc = "Substitute (Visual selection)" ,noremap = true })
    end
  },
  ["tommcdo/vim-exchange"] = {},
  ["ggandor/leap.nvim"] = {},
  ["tpope/vim-fugitive"] = {},
  ["tpope/vim-abolish"] = {},
  ["tpope/vim-repeat"] = {},
  ["tpope/vim-surround"] = {},
  ["tpope/vim-unimpaired"] = {},
  ["wellle/targets.vim"] = {},
  ["gbprod/stay-in-place.nvim"] = {},
  ["iago-lito/vim-visualMarks"] = {},
  ["AndrewRadev/tagalong.vim"] = {},

  ["mg979/vim-visual-multi"] = {
    config = function()
      require "custom.plugins.configs.vim-visual-multi"
    end
  },
  ["bkad/CamelCaseMotion"] = {},
  ["RRethy/vim-illuminate"] = {},
  ["folke/trouble.nvim"] = {
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        vim.keymap.set("n", "gR", function() require("trouble").next({skip_groups = true, jump = true}); end,
          {silent = true, noremap = true}
        ),
      }
    end
  },

  -- code formatting, linting etc
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.configs.null-ls"
    end,
  },

  ["eandrju/cellular-automaton.nvim"] = {},

  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

