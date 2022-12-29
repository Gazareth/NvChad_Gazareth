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
      require "custom.plugins.lspconfig"
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
  ["sharkdp/fd"] = {},

  ["mbbill/undotree"] = {},
  ["Asheq/close-buffers.vim"] = {},
  ["gnikdroy/projections.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require("projections").setup({
        workspaces = {
          "X:\\Development\\Games\\Both",
          "C:\\Users\\Gareth\\AppData\\Local",
          "X:\\Development\\vim\\NvChad",
        },
        patterns = {
          ".git", ".svn", ".hg"
        },
        -- Close nvim-tree window on exit
        store_hooks = {
          pre = function()
            -- nvim-tree 
            local nvim_tree_present, api = pcall(require, "nvim-tree.api")
            if nvim_tree_present then api.tree.close() end

            -- neo-tree
            if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
          end
        },
        restore_hooks = {
          post = function()
            vim.cmd("cd " .. vim.loop.cwd())
          end
        }
      })

      require('telescope').load_extension('projections')

      -- Create command to restore latest session
      local Session = require("projections.session")
      vim.api.nvim_create_user_command("RestoreLastProjectionsSession", function()
        Session.restore_latest()
      end, {})

      -- Autostore session on VimExit
      vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
        callback = function() Session.store(vim.loop.cwd()) end,
      })

      -- Switch to project if vim was started in a project dir
      local switcher = require("projections.switcher")
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
        end,
      })
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
      require('modicator').setup({
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
      })
    end,
  },

  ["yuttie/comfortable-motion.vim"] = {
    config = function()
      local g = vim.g
      g.comfortable_motion_no_default_key_mappings = 1
      g.comfortable_motion_interval = 1000.0 / 120.0
      g.comfortable_motion_friction = 240.0
      g.comfortable_motion_air_drag = 16.0

      g.comfortable_motion_impulse_multiplier = 4  -- Feel free to increase/decrease this value.

      local flickCommand = function(flickAmountMultiplier)
        return function()
          local flickAmountFloor = math.floor(flickAmountMultiplier)
          local winHeight = vim.api.nvim_command_output("echo winheight(0)")
          local cursorJumpAmount = math.abs(math.floor(flickAmountMultiplier * tonumber(winHeight) / 4))
          local cursorJumpDir = "j"

          if(string.sub(flickAmountMultiplier,1,1) == "-") then
            cursorJumpDir = "k"
          end
          local cmd = "normal "..cursorJumpAmount..cursorJumpDir
          vim.cmd("normal "..cursorJumpAmount..cursorJumpDir)
          vim.cmd(":call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * "..flickAmountMultiplier..")")
        end
      end

      vim.keymap.set('n', '<C-d>', flickCommand("2.15"), { desc = "Jump down by half a screen" })
      vim.keymap.set('n', '<C-u>', flickCommand("-2.15"), { desc = "Jump up by half a screen" })
      -- vim.keymap.set('n', '<C-f>', flickCommand("4"), { desc = "Jump down a screen" })
      -- vim.keymap.set('n', '<C-b>', flickCommand("-4"), { desc = "Jump up a screen" })
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
      local g = vim.g

      g.VM_silent_exit = 1
      g.VM_set_statusline = 0

      g.VM_Mono_hl = "VisualMultiCursor"
      g.VM_Extend_hl = "Visual"
      g.VM_Cursor_hl = "VisualModeCursor"
      g.VM_Insert_hl = "InsertModeCursor"
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
      require "custom.plugins.null-ls"
    end,
  },
  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

