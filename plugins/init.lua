local overrides = require "custom.plugins.overrides"

return {

  -- OVERRIDES --
  ["lewis6991/gitsigns.nvim"] = {
    rm_default_opts = true,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    rm_default_opts = true,
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
    -- after = "projections.nvim",
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

  -- Theme is handled through NvChad
  -- ["phanviet/vim-monokai-pro"] = {},

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
  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

