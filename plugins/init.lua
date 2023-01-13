local overrides = require "custom.plugins.overrides"


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

  ["NvChad/ui"] = {
    override_options = overrides.ui
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
  ["ggandor/leap-ast.nvim"] = {
   after = { "leap.nvim", "nvim-treesitter" }
  },
  ["tpope/vim-fugitive"] = {},
  ["tpope/vim-abolish"] = {},
  ["tpope/vim-repeat"] = {},
  -- ["tpope/vim-surround"] = {},
  ["tpope/vim-unimpaired"] = {},
  ["wellle/targets.vim"] = {},
  ["gbprod/stay-in-place.nvim"] = {},
  ["iago-lito/vim-visualMarks"] = {},
  ["AndrewRadev/tagalong.vim"] = {},

  ["kylechui/nvim-surround"] = {
    config = function()
      require("nvim-surround").setup()
    end
  },
  ["andymass/vim-matchup"] = {},

  ["drybalka/tree-climber.nvim"] = {},
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select around function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer", desc = "Select around class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
        }
      }
    })
    end
  },
  -- ["rktjmp/lush.nvim"] = {},
  -- ["Dkendal/nvim-treeclimber"] = {
  --   requires = { "nvim-treesitter/nvim-treesitter", "rktjmp/lush.nvim" },
  --   after = "ui",
  --   config = function()
  --     local present, treeclimber = pcall(require, "lush")
  --     if(present) then
  --       require('nvim-treeclimber').setup()
  --     end
  --   end
  -- },

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

  -- ["williamboman/mason-lspconfig.nvim"] = {
  --   setup = {
  --     ensure_installed = {
  --       "sumneko_lua",
  --     }
  --   }
  -- },

  -- code formatting, linting etc
  -- ["jose-elias-alvarez/null-ls.nvim"] = {
  --   after = "nvim-lspconfig",
  --   config = function()
  --     require "custom.plugins.configs.null-ls"
  --   end,
  -- },

  ["eandrju/cellular-automaton.nvim"] = {},

  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

