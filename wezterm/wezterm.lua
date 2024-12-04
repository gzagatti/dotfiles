-- wezterm config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "wezterm"
config.default_domain = "local"
config.default_prog = { "wsl.exe", "--cd", "~" }
-- config.default_domain = "WSL:Ubuntu"
-- config.default_cwd = wezterm.home_dir
config.pane_focus_follows_mouse = false
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  fade_out_function = "EaseOut",
}

-- keys
config.keys = {
  {
      key = "+",
    mods = "CTRL|SHIFT",
    action = wezterm.action.Nop,
  },
  {
      key = "_",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "|",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "r",
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
}

-- theme
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
  cursor_border = "#52ad70",

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

return config
