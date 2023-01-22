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

-- This provides additional information in the statusbar, such as:
--  - Setting the filename to bold and adding [+] when there are unsaved changes
--  - Showing the current folder path with breadcrumbs from the project root (cd)
--  - Distinguish the current LSP from the "LSP: " text
--  - Show full path to current project dir
return {
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
      local EMPTY_FILENAME = "[Empty]"
      local filename = (fn.expand "%" == "" and EMPTY_FILENAME) or fn.expand "%:t"
      local foldername = (fn.expand "%"  == "" and "") or fn.expand("%:.:h:t"):gsub("\\", "/")
      local foldername_head = ""
      local folder_info = ""

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
        foldername = " " .. foldername .. " "
        folder_info = " " .. "%#St_folder_head#" .. foldername_head .. "%#St_file_folder_info#" .. foldername
        folder_info = folder_info:gsub("/", file_path_seps)
      end

      filename = fileicon .. filename
      -- local file_portion = "%#St_file_info#" .. file_name .. " " .. "%#St_file_sep#" .. sep_r .. "%#St_file_git_sep#" .. sep_r
      local file_color = "%#" .. ((vim.bo.modified and "St_file_modified") or "St_file_info") .. "#"
      local modified_suffix = (vim.bo.modified and " [+]") or ""
      local file_portion = file_color .. filename .. modified_suffix .. " " .. "%#St_file_sep#" .. sep_r
      local folder_portion = "%#St_file_folder_info#" .. folder_info .. " " .. "%#St_folder_sep#" .. sep_r
      local file_info = file_portion .. folder_portion

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

      -- CWD
      local project_indicator = ""
      local project_name = project_name_display()
      if #project_name then
        project_indicator = "%#St_cwd_project#" .. "["..project_name .. "] "
      end

      local dir_icon = "%#St_cwd_icon#" .. " "
      local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

      local cwd_expr = (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name .. project_indicator)) or ""

      return {
        fileInfo = function() return file_info end,
        LSP_status = function() return lsp_status end,
        cwd = function() return cwd_expr end,
      }
    end,
  },
}

-- return { statusline = { overriden_modules = function() return {} end } }
