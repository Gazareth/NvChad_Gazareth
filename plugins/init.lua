local overrides = require "custom.plugins.overrides"
local get_keys = require("custom.functions.packer").get_keys

local allSurrounds = { "f", "t","[", "]", "{", "}", "(", ")", "\"", "'" }
local allWordMotions = vim.list_extend({ "w", "W", "p", "q", "b" }, allSurrounds)
local allVimCaserKeys = { "m", "p", "c", "_", "u", "U", "t", "s", "<space>", "-", "k", "K", "." }
local allVimUnimpairedKeys = { "a", "A", "b", "B", "l", "L", "<C-L>", "q", "Q", "<C-Q>", "t", "T", "<C-T>", "f", "n", "<space>", "e", "x", "xx", "u", "uu", "y", "yy", "C", "CC"  }

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
    requires = "nvim-lua/plenary.nvim",
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
    -- disable = false,
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

  ["nvim-tree/nvim-tree.lua"] = {
    override_options = overrides.nvimtree,
  },

  ["NvChad/ui"] = {
    override_options = overrides.ui
  },

  -- OVERRIDES END --

  ["nathom/filetype.nvim"] = {},

  ["tomarrell/vim-npr"] = {},

  ["mbbill/undotree"] = {},

  ["Gazareth/projections.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require "custom.plugins.configs.projections"
    end
  },

  ["zane-/cder.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require('telescope').load_extension('cder')
    end
  },

  ["tpope/vim-fugitive"] = {
    opt = true,
    cmd = {
      "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gsplit",
      "Gread", "Gwrite", "Ggrep", "Glgrep", "Gmove",
      "Gdelete", "Gremove", "Gbrowse",
    },
  },

  ["numToStr/BufOnly.nvim"] = {
    cmd = "BufOnly"
  },

  ["AndrewRadev/undoquit.vim"] = {
    cmd = "Undoquit",
    config = function()
      vim.g.undoquit_mapping = ""
      vim.g.undoquit_tab_mapping = ""
    end
  },

  -- ["LukasPietzschmann/telescope-tabs"] = {
  --   requires = { "nvim-telescope/telescope.nvim" },
  --   after = "telescope.nvim",
  --   config = function()
  --     require'telescope-tabs'.setup{
  --       close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
  --       close_tab_shortcut_n = 'dd',     -- if you're in normal mode
  --     }
  --   end
  -- },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require('telescope').load_extension('ui-select')
    end
  },

  -- Multi-coloured indent indicators
  -- ["mawkler/modicator.nvim"] = {
  --   after = "base46",
  --   config = function()
  --     require "custom.plugins.configs.modicator"
  --   end,
  -- },

  ["yuttie/comfortable-motion.vim"] = {
    config = function()
      require "custom.plugins.configs.comfortable-motion"
    end
  },

  ["wfxr/minimap.vim"] = {
    config = function()
      vim.g.minimap_width = 5
    end
  },

  ["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh", "TroubleClose" },
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        vim.keymap.set("n", "gR", function() require("trouble").next({skip_groups = true, jump = true}); end,
          {silent = true, noremap = true}
        ),
      }
    end
  },

  ["folke/zen-mode.nvim"] = {
    cmd = { "ZenMode" },
    config = function()
      require("zen-mode").setup {
        window = {
          width = .75
        }
      }
    end
  },

  ["folke/twilight.nvim"] = {
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" }
  },

  ["beauwilliams/focus.nvim"] = {
    config = function() require("focus").setup() end
  },

  ["folke/lsp-colors.nvim"] = {},

  ["echasnovski/mini.cursorword"] = {
    config = function()
      require('mini.cursorword').setup()
    end
  },

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  ["ofirgall/open.nvim"] = {
    -- after = "plenary.nvim", -- Not needed because we load late with "Keys"
    keys = {"n","gx"},
    config = function()
      require("open").setup()
      vim.keymap.set('n', 'gx', require('open').open_cword)
    end,
  },

  ["tpope/vim-repeat"] = {},

  ["tpope/vim-unimpaired"] = {
    keys = vim.list_extend(
      vim.list_extend(
        get_keys({"n"}, {{"[", "]"}, allVimUnimpairedKeys}),
        get_keys({"n"}, {{">", "<", "="}, {"p", "P"}})
      ),
      get_keys({"x"}, {{"[", "]"}, { "x", "u", "y", "c" }})
    )
  },

  ["gbprod/stay-in-place.nvim"] = {},

  ["andymass/vim-matchup"] = {},

  ["AndrewRadev/tagalong.vim"] = {},

  ["arthurxavierx/vim-caser"] = {
    keys = vim.list_extend(
      vim.list_extend(
        get_keys({"n"}, {{"gs"}, {"a", "i"}, allVimCaserKeys, allWordMotions}),
        get_keys({"n"}, {{"gs"}, { "w", "W" }})
      ),
      get_keys({"x"}, {{"gs"}, {"w", "W"}})
    )
  },

  ["mg979/vim-visual-multi"] = {
    config = function()
      require "custom.plugins.configs.vim-visual-multi"
    end
  },

  ["gbprod/substitute.nvim"] = {
    keys = vim.list_extend(
      get_keys({"n"}, {{"s", "ss", "S"}}),
      get_keys({"x"}, {{"s"}})
    ),
    config = function()
      local subst = require("substitute")
      subst.setup()
      vim.keymap.set("n", "s", subst.operator, { desc = "Substitute (With motion)" ,noremap = true })
      vim.keymap.set("n", "ss", subst.line, { desc = "Substitute (Line)" ,noremap = true })
      vim.keymap.set("n", "S", subst.eol, { desc = "Substitute (To end of line)" ,noremap = true })
      vim.keymap.set("x", "s", subst.visual, { desc = "Substitute (Visual selection)" ,noremap = true })
    end
  },

  ["tommcdo/vim-exchange"] = {
    keys = vim.list_extend(
      get_keys({"n"}, {{"cx", "cxx", "cxc"}}),
      get_keys({"x"}, {{"X"}})
    )
  },

  ["ggandor/leap.nvim"] = {},

  ["ggandor/leap-ast.nvim"] = {
    after = { "leap.nvim", "nvim-treesitter" }
  },

  ["Gazareth/leap-spooky.nvim"] = {
    branch = "feat/auto-targets",
    config = function()
      require('leap-spooky').setup({
        custom_textobjects = {
          "o", "a", "f", "F", "v"
        },
        auto_targets = true
      })
    end
  },

  ["echasnovski/mini.ai"] = {
    config = function()
      local mini_ai = require('mini.ai')
      local spec_treesitter = mini_ai.gen_spec.treesitter

      local word_modes = {
        ["word"] = "word",
        ["non_word"] = "non_word",
        ["whitespace"] = "whitespace"
      }

      local character_types = {
        [word_modes.word] = "%w_",
        [word_modes.non_word] = "^%w_",
        [word_modes.whitespace] = "%s"
      }

      local get_selected_region = function()
        local start_pos = vim.api.nvim_buf_get_mark(0, "<")

        local end_pos = vim.api.nvim_buf_get_mark(0, ">")

        return { start_pos = start_pos, end_pos = end_pos }
      end

      -- "word" helpers
      local word_pattern = "[" .. character_types.word .. "]"
      local non_word_pattern = "[" .. character_types.non_word .. "]"
      local initial_word_pattern = { "%f", word_pattern, "()", word_pattern, "+" }

      -- Sequence end is found with a frontier pattern of end_pattern followed by any number of end_pattern (including 0)
      local end_sequence = function(end_pattern) return { "%f", end_pattern, "()%s*()", end_pattern, "*"  } end
      local any_space = "%s*"

      local word_captures = {
        [word_modes.word] = "[^%w_]+()%s*()[%w_]+()%f[^%w_]%s*()",
        [word_modes.non_word] = "[%w_]+()%s*()[^%w_]+()%f[%w_%s]%s*()",
        [word_modes.whitespace] = { ["i"] = "[^%s]+()[%s]+()[^%s]+", ["a"] = "[^%s]+()()[%s]+()()[^%s]+" }
      }

      require('mini.ai').setup({
        custom_textobjects = {
          a = spec_treesitter({
            a = { '@parameter.outer' },
            i = { '@parameter.inner' },
          }),
          F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
          o = spec_treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }),
          v = spec_treesitter({
            a = { '@pair.outer`' },
            i = { '@pair.inner`' },
          }),
          ["1"] = function(ai_type, text_obj, opts)

            -- If we're in visual mode, retain the current selected region, and act as if the cursor is at the end
            local visual_mode = opts.vis_mode == nil and true or false

            local current_selection = {}

            if(visual_mode) then
              -- Store current selection
              current_selection = get_selected_region()
              -- Exit visual mode
              local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
              vim.api.nvim_feedkeys(esc, 'x', false)


              vim.schedule(function() print("stored_regions: ", vim.inspect(current_selection)) end)

              -- put cursor at end of previous position
              vim.api.nvim_win_set_cursor(0, current_selection.end_pos)
            end

            -- Find out what kind of character is under the cursor
            local col = vim.api.nvim_win_get_cursor(0)[2] + 1
            local line = vim.api.nvim_get_current_line()
            local char = line:sub(col,col)

            -- Determine which "mode" we are in (the "w" text object behaves differently depending on context)
            -- 3 modes:
            -- - "word":
            --     (i) capture all characters between alphanumeric & whitespace characters
            --     (a) As above but include trailing space, or leading space if no trailing space
            -- - "non_word":
            --     (i) Capture all non-word characters between whitespace
            --     (a) As above but include trailing space, or leading space if no trailing space
            -- - "whitespace":
            --     (i) Capture all consecutive spaces between non-space characters
            --     (a) As above but also capture next group of consecutive characters belonging to the same word/non-word set
            -- And if we're in visual mode, respect current selection whilst searching ahead
            local word_mode = ""

            for k, v in pairs(character_types) do
              word_mode = string.find(char, "[" .. v .. "]") and k or word_mode
            end

            local final_pattern_group = word_captures[word_mode]
            local final_pattern = type(word_captures) == "table" and final_pattern_group[ai_type] or final_pattern_group

            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.schedule(function() print("Searching forwards from: ", vim.inspect(cursor_pos)) end)
            local found_region = mini_ai.find_textobject_region({ final_pattern }, ai_type, opts)
            vim.schedule(function() print("old selection: ", vim.inspect(current_selection)) end)
            vim.schedule(function() print("final region: ", vim.inspect(found_region)) end)

            return found_region
          end,
          ["0"] = function(ai_type, text_obj, opts)
            -- First find out what kind of character is under the cursor
            local col = vim.api.nvim_win_get_cursor(0)[2] + 1
            local line = vim.api.nvim_get_current_line()
            local char = line:sub(col,col)

            -- Determine which "mode" we are in (the "w" text object behaves differently depending on context)
            -- 3 modes:
            -- - "word":
            --     (i) capture all characters between alphanumeric & whitespace characters
            --     (a) As above but include trailing space, or leading space if no trailing space
            -- - "non_word":
            --     (i) Capture all non-word characters between whitespace
            --     (a) As above but include trailing space, or leading space if no trailing space
            -- - "whitespace":
            --     (i) Capture all consecutive spaces between non-space characters
            --     (a) As above but also capture next group of consecutive characters belonging to the same word/non-word set
            local word_mode = ""

            for k, v in pairs(character_types) do
              word_mode = char:find(v) and k or word_mode
            end

            -- If we're currently within a word
            local is_in_word = char:find(word_pattern)

            -- Start with any spaces being captured by "a" mode
            local pattern = {  }
            -- local pattern = { "()" }

            if is_in_word then
              vim.list_extend(pattern, initial_word_pattern)
            else
              -- If cursor not in a "word", include the "non-word" characters, and end at the next valid word characters
              -- Frontier pattern to find beinning of "non-word", then capture from there onwards, at least one "non-word" character.
              vim.list_extend(pattern,  { non_word_pattern, "-", "()", non_word_pattern, "+" })
              -- With non-words we also want to end the current pattern at the start of the next valid word, so we can continue searching onwards
            end

            vim.list_extend(pattern, { "()" })

            if opts.n_times == 1 then
              local end_pattern = is_in_word and non_word_pattern or word_pattern
              vim.list_extend(pattern, end_sequence(end_pattern))
            end

            vim.schedule(function() print("final pattern (" .. ai_type .. "): " .. table.concat(pattern)) end)

            -- if ai_type == "a" then
            -- -- TODO: find single word and prune trailing space if there is a leading space when using "a" mode
            -- end

            if opts.n_times > 1 and not opts.discrete then
              -- for each additional word being searched for, add more words
              for _ = 2, opts.n_times do
                -- At least one 'non word character' causes a separation to the next event
                vim.list_extend(pattern, { non_word_pattern, "+", "%f", word_pattern, word_pattern, "-" })
              end

              -- vim.list_extend(pattern, end_sequence(word_pattern))
              vim.list_extend(pattern, { "()", "()"  })

              opts.n_times = 1
            end

            local full_pattern = table.concat(pattern)

            opts.search_method = "cover_or_next"
            -- vim.schedule(function() print(full_pattern) end)
            return mini_ai.find_textobject_region({ full_pattern }, ai_type, opts)
          end
          -- W = { '[%s]+()()%S+()%s*()' },
        },
        -- search_method@ = "cover"
      })
    end
  },

  ["echasnovski/mini.surround"] = {
    config = function()
      require('mini.surround').setup({
        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 500,

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          add = 'ys', -- Add surrounding in Normal and Visual modes
          delete = 'ds', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'cs', -- Replace surrounding
          update_n_lines = '<leader>ysn', -- Update `n_lines`

          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'n', -- Suffix to search with "next" method
        },

        -- How to search for surrounding (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
        -- see `:h MiniSurround.config`.
        search_method = 'cover_or_nearest',
      })
    end
  },

  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  },

  -- ["kylechui/nvim-surround"] = {
  --   keys = vim.list_extend(
  --     get_keys({"n"}, {{ "y", "d", "c" }, {"s"}, {"i", "a"}, allWordMotions}),
  --     get_keys({"x"}, {{ "S" }, allSurrounds})
  --   ),
  --   tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   config = function()
  --     require("nvim-surround").setup()
  --   end
  -- },

  ["drybalka/tree-climber.nvim"] = {},

  ["nvim-treesitter/playground"] = {},

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

  -- ["tzachar/local-highlight.nvim"] = {
  --   config = function()
  --     require('local-highlight').setup({
  --     })
  --   end
  -- },

  -- code formatting, linting etc
  -- ["jose-elias-alvarez/null-ls.nvim"] = {
  --   after = "nvim-lspconfig",
  --   config = function()
  --     require "custom.plugins.configs.null-ls"
  --   end,
  -- },

  ["eandrju/cellular-automaton.nvim"] = {
    cmd = "CellularAutomaton"
  },

  -- remove plugin
  -- ["hrsh7th/cmp-path"] = false,
}

