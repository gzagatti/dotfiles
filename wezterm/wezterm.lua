-- wezterm config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local wsl_domains = wezterm.default_wsl_domains()

local function current_working_dir(pane)
  local cwd = pane:get_current_working_dir()
  if not (cwd and cwd.file_path) then
    return nil
  end

  -- In WSL, OSC 7 reports file://host/Distro/path, but WSL expects /path.
  for _, domain in ipairs(wsl_domains) do
    local prefix = "/" .. domain.distribution .. "/"
    if cwd.file_path:sub(1, #prefix) == prefix then
      return "/" .. cwd.file_path:sub(#prefix + 1)
    end
  end

  return cwd.file_path
end

config.term = "wezterm"
config.front_end = "WebGpu"
-- Use WezTerm's WSL domain instead of spawning wsl.exe manually so
-- pane cwd tracking can be reused by splits and tabs.
config.wsl_domains = wsl_domains
for _, domain in ipairs(config.wsl_domains) do
  if domain.distribution ~= "docker-desktop" then
    config.default_domain = domain.name
    break
  end
end
config.default_cwd = "~"
config.pane_focus_follows_mouse = false
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  fade_out_function = "EaseOut",
}
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- keys
config.enable_kitty_keyboard = false
config.bold_brightens_ansi_colors = "No"

config.keys = {
  {
    key = "+",
    mods = "CTRL|SHIFT",
    action = wezterm.action.Nop,
  },
  {
    key = "_",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      pane:split({
        direction = "Bottom",
        cwd = current_working_dir(pane),
      })
    end),
  },
  {
    key = "|",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      pane:split({
        direction = "Right",
        cwd = current_working_dir(pane),
      })
    end),
  },
  {
    key = "r",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
  },
  {
    key = "}",
    mods = "CTRL|SHIFT",
    action = wezterm.action.RotatePanes("Clockwise"),
  },
  {
    key = "d",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_window()
    end),
  },
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnCommandInNewTab({ cwd = "~" }),
  },
  {
    key = "s",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PaneSelect({ show_pane_ids = true }),
  },
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendString('\x1b[13;2u'),
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.SendString('\x1b[13;3u'),
  },
  {
    key = 'Enter',
    mods = 'CTRL',
    action = wezterm.action.SendString('\x1b[13;5u'),
  },
}

-- theme
-- font
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Consolas",
})
config.font_size = 13

-- tab
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- inactive pane
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}

-- color
config.colors = {
  -- The default text color
  foreground = "#333333",
  -- The default background color
  background = "#f8fbf8",

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = "#0fb300",
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = "#000000",
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = "#0fb300",

  -- the foreground color of selected text
  selection_fg = "#000000",
  -- the background color of selected text
  selection_bg = "#8ed3ff",

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = "#222222",

  -- The color of the split lines between panes
  split = "#444444",

  ansi = {
    "#f8fbf8", -- black
    "#cd0000", -- red
    "#0fb300", -- green
    "#ffa500", -- yellow
    "#0000ff", -- blue
    "#ba36a5", -- magenta
    "#21bdff", -- cyan
    "#333333", -- white
  },
  brights = {
    "#333333", -- black
    "#ffe6e4", -- red
    "#ccffcc", -- lime
    "#fff68f", -- yellow
    "#e5f4fb", -- blue
    "#ffe4ff", -- magenta
    "#e0ffff", -- cyan
    "#686868", -- white
  },

  -- TODO: tweak the colors below? what are they for?
  -- Arbitrary colors of the palette in the range from 16 to 255
  -- indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  -- compose_cursor = 'orange',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  -- copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  -- copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  -- copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  -- copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  -- quick_select_label_bg = { Color = 'peru' },
  -- quick_select_label_fg = { Color = '#ffffff' },
  -- quick_select_match_bg = { AnsiColor = 'Navy' },
  -- quick_select_match_fg = { Color = '#ffffff' },

  visual_bell = "#a9a9a9",

  tab_bar = {
    background = "#a9a9a9",

    active_tab = {
      fg_color = "#85ceeb",
      bg_color = "#335ea8",
      intensity = "Bold",
    },

    inactive_tab = {
      fg_color = "#f8fbf8",
      bg_color = "#a9a9a9",
      intensity = "Half",
    },

    inactive_tab_hover = {
      fg_color = "#f8fbf8",
      bg_color = "#a9a9a9",
      intensity = "Bold",
    },

    new_tab = {
      fg_color = "#f8fbf8",
      bg_color = "#a9a9a9",
      intensity = "Half",
    },

    new_tab_hover = {
      fg_color = "#f8fbf8",
      bg_color = "#a9a9a9",
      intensity = "Bold",
    },
  },
}

config.pane_select_bg_color = "#ffffff"
config.pane_select_fg_color = "#000000"

return config
