-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

-- This will hold the configuration.
local config = wezterm.config_builder()
-- For example, changing the color scheme:
config.color_scheme = 'Gruvbox dark, hard (base16)'

-- config.font = wezterm.font_with_fallback('Iosevka Nerd Font')
config.font = wezterm.font_with_fallback{
  { -- Normal text
    family='Iosevka',
    harfbuzz_features={ 'calt', 'liga', 'dlig', 'ss15'},
  },
  'Symbols Nerd Font Mono'}
-- Copied from https://github.com/HaleTom/dotfiles/blob/a2049913a35676eb4c449ebaff09f65abe055f62/wezterm/.config/wezterm/wezterm.lua#L93 
-- Monaspace:  https://monaspace.githubnext.com/
-- Based upon, contributed to:  https://gist.github.com/ErebusBat/9744f25f3735c1e0491f6ef7f3a9ddc3
  -- config.font = wezterm.font_with_fallback{
  -- { -- Normal text
  -- family='Monaspace Neon',
  -- harfbuzz_features={ 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09' },
  -- stretch='UltraCondensed', -- This doesn't seem to do anything
-- },'Symbols Nerd Font Mono'
-- }

-- config.font_rules = {
  -- { -- Italic
  --   intensity = 'Normal',
  --   italic = true,
  --   font = wezterm.font({
  --     family="Monaspace Radon",  -- script style
  --     -- family='Monaspace Xenon', -- courier-like
  --     style = 'Italic',
  --   })
  -- },

  -- { -- Bold
  --   intensity = 'Bold',
  --   italic = false,
  --   font = wezterm.font( {
  --     family='Monaspace Radon',
  --     weight='ExtraBold',
  --     -- weight='Bold',
  --     })
  -- },

  -- { -- Bold Italic
  --   intensity = 'Bold',
  --   italic = true,
  --   font = wezterm.font( {
  --     family='Monaspace Xenon',
  --     style='Italic',
  --     weight='Bold',
  --     }
  --   )
  -- },
-- }



-- config.font = wezterm.font_with_fallback{
--   { -- Normal text
--   family='Victor Mono',
--   harfbuzz_features={ 'calt', 'liga', 'dlig', 'ss01'},
--   weight='Medium',
--   },
--   'Symbols Nerd Font Mono'
-- }

-- config.font_rules = {
--   { -- Italic
--     intensity = 'Normal',
--     italic = true,
--     font = wezterm.font({
--       family="Victor Mono",
--       style = 'Italic',
--     })
--   },

--   { -- Bold
--     intensity = 'Bold',
--     italic = false,
--     font = wezterm.font( {
--       family='Victor Mono',
--       weight='Bold',
--       })
--   },

--   { -- Bold Italic
--     intensity = 'Bold',
--     italic = true,
--     font = wezterm.font( {
--       family='Victor Mono',
--       style = 'Oblique',
--       weight='Bold',
--       }
--     )
--   },
-- }



config.font_size = 20.0

config.hide_tab_bar_if_only_one_tab = true

config.native_macos_fullscreen_mode = true

config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
