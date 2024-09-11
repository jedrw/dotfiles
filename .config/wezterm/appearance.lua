local wezterm = require 'wezterm'
local sys = require 'sys'
local module = {}

function module.apply_to_config(config)
    config.color_scheme = 'Dracula (Official)'
    local font_family = 'Intel One Mono'
    config.font = wezterm.font(font_family)
    if sys.is_os('linux') then
        config.font_size = 16.0
    else
        config.font_size = 20.0
    end
    config.line_height = 1

    config.window_frame = {
        font = wezterm.font({ family = font_family, weight = "Bold" }),
        active_titlebar_bg = "rgba(0,0,0,0.8)",
        inactive_titlebar_bg = "rgba(0,0,0,0.8)",
    }

    config.window_frame.font_size = config.font_size - 4

    config.mouse_wheel_scrolls_tabs = false
    config.prefer_to_spawn_tabs = false
    config.pane_focus_follows_mouse = true
    config.scrollback_lines = 20000
    config.window_background_opacity = 0.8
    config.window_decorations = "RESIZE"

    local color_scheme = wezterm.get_builtin_color_schemes()[config.color_scheme]
    local fg_color = wezterm.color.parse(color_scheme.foreground)

    config.colors = {
        background = "black",
        tab_bar = {
            background = "rgba(0,0,0,0.8)",
            active_tab = {
                -- The color of the background area for the tab
                bg_color = "rgba(80,80,80,0.8)",
                fg_color = fg_color
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
        left = 0,
        right = 0,
        bottom = 0,
        top = 0,
    }
end

-- local function tab_title(tab_info)
--     local title = tab_info.tab_title
--     -- if the tab title is explicitly set, take that
--     if title and #title > 0 then
--         return title
--     end
--     -- Otherwise, use the process name of the active pane
--     -- in that tab
--     local procname = tab_info.active_pane.foreground_process_name
--     if procname == "" then
--         return "uknown"
--     end

--     return procname
-- end

-- Tried playing with this, I have to return everythig not just the title of the
-- tab. so needs more playing then I have time for right now
-- wezterm.on(
--     'format-tab-title',
--     function(tab, tabs, panes, config, hover, max_width)
--         tab.title = tab_title(tab)
--         return tab
--     end
-- )

return module
