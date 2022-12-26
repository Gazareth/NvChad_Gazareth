local overrides = require "custom.plugins.overrides"
-- local colors = require("base46").get_theme_tb "base_30"

return {

  ["nvim-telescope/telescope.nvim"] = {
    override_options = overrides.telescope,
  },

  ["goolord/alpha-nvim"] = {
    disable = false,
    -- after = "projections.nvim",
    override_options = overrides.alpha,
  },

  -- Override plugin definition options
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  -- overrde plugin configs
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

  -- My installed packages --
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
      })

      -- Bind <leader>fp to Telescope projections
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

  -- ["Shatur/neovim-session-manager"] = {},
  -- ["olimorris/persisted.nvim"] = {
  --   after = "telescope.nvim",
  --   config = function()
  --     require("persisted").setup()
  --     require("telescope").load_extension("persisted") -- To load the telescope extension
  --   end,
  -- },

  ["ahmedkhalf/project.nvim"] = {
    --   after = "telescope.nvim",
    config = function()
      --     require('telescope').load_extension('projects')
      require("project_nvim").setup({
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        -- Methods of detecting the root directory. **"lsp"** uses the native neovim
        -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
        -- order matters: if one is not detected, the other is used as fallback. You
        -- can also delete or rearangne the detection methods.
        detection_methods = { "lsp", "pattern" },

        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

        -- Table of lsp clients to ignore by name
        -- eg: { "efm", ... }
        ignore_lsp = {},

        -- Don't calculate root dir on specific directories
        -- Ex: { "~/.cargo/*", ... }
        exclude_dirs = {},

        -- Show hidden files in telescope
        show_hidden = false,

        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = true,
      })
    end,

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath("data"),
  },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require('telescope').load_extension('projects')
    end,
  },

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
  ["szw/vim-maximizer"] = {},
  ["folke/lsp-colors.nvim"] = {},

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  ["sharkdp/fd"] = {},

  ["phanviet/vim-monokai-pro"] = {},

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

  ["mg979/vim-visual-multi"] = {},
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

  ["numToStr/Comment.nvim"] = {},

  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

