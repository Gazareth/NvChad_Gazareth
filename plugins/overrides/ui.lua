--  - Set the filename to bold and adding [+] when there are unsaved changes
--  - Showing the current folder path with breadcrumbs from the project root (cd)
--  - Distinguish the current LSP from the "LSP: " text
--  - Show full path to current project dir
return {
  statusline = {
    overriden_modules = function()
      local sep_style = vim.g.statusline_sep_style
      local separators = (type(sep_style) == "table" and sep_style) or require("nvchad_ui.icons").statusline_separators[sep_style]
      local sep_l = separators["left"]
      local sep_r = separators["right"]

      local fn = vim.fn

      local get_current_project = function()
        local projections_available, Switcher = pcall(require, "projections.switcher")
        if(projections_available) then
          return Switcher:get_current()
        else
          return nil
        end
      end

      local in_project = function()
        local info = get_current_project()
        if info ~= nil and #info.path > 0 then
          return true
        end
        return false
      end

      local current_project_match = function()
        if in_project() then
          local info = get_current_project()
          local file_dir = vim.fn.expand("%:p:h")
          if info ~= nil and #info.path > 0 then
            -- print("Checking project matches file:", file_dir, info.path)
            if string.match(file_dir, info.path) then
              return 1
            else
              return 0
            end
          end
        end
        return -1
      end

      local project_name_display = function()
        local project_matches = current_project_match()
        if project_matches == 1 then
          return "Project"
        elseif project_matches == 0 then
          return "Project: "..vim.loop.cwd()
        end
        return "No project"
      end

      local function get_file_info()
        -- FILENAME
        local fileicon = " "
        local EMPTY_FILENAME = "[Empty]"
        local filename = (fn.expand "%" == "" and EMPTY_FILENAME) or fn.expand "%:t"
        local foldername = (fn.expand "%"  == "" and "") or fn.expand("%:.:h:t"):gsub("\\", "/")
        local foldername_head = ""
        local folder_info = ""

        local file_color = "%#" .. ((vim.bo.modified and filename ~= EMPTY_FILENAME and "St_file_modified") or "St_file_info") .. "#"
        local file_path_seps = "%%#St_folder_chevs#" .. "  " .. "%%#St_folder_head#"

        if filename ~= EMPTY_FILENAME then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(filename)
            fileicon = (ft_icon ~= nil and ft_icon) or ""
          end

          filename = " " .. filename
        end

        if foldername ~= "" then
          foldername_head = fn.expand("%:.:h:h"):gsub("\\", "/") .. "/"
          foldername = "  " .. foldername .. " "
          folder_info = " " .. "%#St_folder_head#" .. foldername_head .. "%#St_file_folder_info#" .. foldername
          folder_info = folder_info:gsub("/", file_path_seps)
        end

        filename = fileicon .. filename
        local modified_suffix = (vim.bo.modified and " [+]") or ""
        local file_portion = file_color .. filename .. modified_suffix .. " " .. "%#St_file_sep#" .. sep_r

        -- Don't write the full file path out when we're in a file from outside the project directory tree
        if in_project() then
          if current_project_match() ~= 1 then
            folder_info = "%#St_folder_head# File exists outside of project folder"
          end
        end

        local folder_portion = "%#St_file_folder_info#" .. folder_info .. " " .. "%#St_folder_sep#" .. sep_r

        return file_portion .. folder_portion
      end

      local function get_lsp_status()
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
      end

      local function get_cwd_display()
        local dir_icon = "%#St_cwd_icon#" .. " "
        local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
        -- CWD
        local project_indicator = ""
        local project_name = project_name_display()
        if #project_name then
          project_indicator = "%#St_cwd_project#" .. "["..project_name .. "] "
        end
        return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name .. project_indicator)) or ""
      end


      return {
        fileInfo = get_file_info,
        LSP_status = get_lsp_status,
        cwd = get_cwd_display,
      }
    end,
  },
}

-- return { statusline = { overriden_modules = function() return {} end } }
