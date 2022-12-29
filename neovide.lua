local g = vim.g

-- vim.opt.guicursor = ""
vim.opt.guifont = { "FiraCode_NFM:h11:#e-subpixelantialias:#h-none" }
-- g.neovide_scale_factor = 1.0
g.neovide_cursor_vfx_mode = "wireframe"
-- g.neovide_cursor_vfx_particle_lifetime = 2.5
-- g.neovide_cursor_vfx_particle_density = 64.0
-- g.neovide_cursor_vfx_particle_speed = 12.0
-- g.neovide_floating_blur_amount_x = 2.0
-- g.neovide_floating_blur_amount_y = 2.0
-- g.neovide_transparency = 0.985


-- g.neovide_profiler = true
g.neovide_refresh_rate = 120
-- g.neovide_refresh_rate_idle = 120
-- g.neovide_no_idle = true

g.neovide_scroll_animation_length = 0.375

g.neovide_hide_mouse_when_typing = true

g.neovide_remember_window_size = true

vim.keymap.set("n", "<F11>", function()
  if (g.neovide_fullscreen == true) then
    g.neovide_fullscreen = false
  else
    g.neovide_fullscreen = true
  end
end
)

