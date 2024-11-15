local wezterm = require 'wezterm'
local sys = require 'sys'
local module = {}

function module.apply_to_config(config)
    config.color_scheme = 'Dracula (Official)'
    local font_family = 'Intel One Mono'
    config.font = wezterm.font(font_family)
    if sys.is_os('linux') then
        config.font_size = 16.0
        config.window_decorations = "NONE"
    else
        config.font_size = 20.0
        config.window_decorations = "RESIZE"
    end
    config.line_height = 1

    config.window_frame = {
        font = wezterm.font({ family = font_family, weight = "Bold" }),
        font_size = config.font_size - 4,
        active_titlebar_bg = "rgba(10,10,10,1)",
        inactive_titlebar_bg = "rgba(10,10,10,1)",
    }

    config.mouse_wheel_scrolls_tabs = false
    config.prefer_to_spawn_tabs = false
    config.pane_focus_follows_mouse = true
    config.scrollback_lines = 20000
    config.window_background_opacity = 0.8

    local color_scheme = wezterm.get_builtin_color_schemes()[config.color_scheme]
    local fg_color = wezterm.color.parse(color_scheme.foreground)

    config.colors = {
        background = "black",

        tab_bar = {
            active_tab = {
                -- The color of the background area for the tab
                bg_color = "rgba(80,80,80,0.8)",
                fg_color = fg_color,
            },
            inactive_tab = {
                -- The color of the background area for the tab
                bg_color = "rgba(30,30,30,0.8)",
                fg_color = fg_color
            },
            inactive_tab_hover = {
                -- The color of the background area for the tab
                bg_color = "rgba(55,55,55,0.8)",
                fg_color = fg_color
            },
            new_tab = {
                -- The color of the background area for the tab
                bg_color = "rgba(55,55,55,0.8)",
                fg_color = fg_color
            },
            new_tab_hover = {
                -- The color of the background area for the tab
                bg_color = "rgba(80,80,80,0.8)",
                fg_color = fg_color
            },
        },
    }

    config.hide_tab_bar_if_only_one_tab = false
    config.tab_bar_at_bottom = false
    config.use_fancy_tab_bar = true
    config.enable_scroll_bar = false

    config.window_padding = {
        -- Shrug
        top = 0,
        right = 5,
        bottom = 0,
        left = 10,
    }
end

return module
