local wezterm = require "wezterm"
local projects = require "projects"
local module = {}

function module.apply_to_config(config)
    local repos_dir = wezterm.home_dir .. "/repos"
    local repos = projects.get_repos(repos_dir)
    config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 }
    local keys = {
        {
            key = "r",
            mods = "LEADER",
            action = wezterm.action.ReloadConfiguration,
        },
        {
            key = "%",
            mods = "LEADER|SHIFT",
            action = wezterm.action.SplitVertical,
        },
        {
            key = "\"",
            mods = "LEADER|SHIFT",
            action = wezterm.action.SplitHorizontal,
        },
        {
            key = "RightArrow",
            mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(1),
        },
        {
            key = "LeftArrow",
            mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(-1),
        },
        {
            key = "LeftArrow",
            mods = "LEADER|SHIFT",
            action = wezterm.action.ActivatePaneDirection("Left"),
        },
        {
            key = "DownArrow",
            mods = "LEADER|SHIFT",
            action = wezterm.action.ActivatePaneDirection("Down"),
        },
        {
            key = "UpArrow",
            mods = "LEADER|SHIFT",
            action = wezterm.action.ActivatePaneDirection("Up"),
        },
        {
            key = "RightArrow",
            mods = "LEADER|SHIFT",
            action = wezterm.action.ActivatePaneDirection("Right"),
        },
        {
            key = "x",
            mods = "LEADER",
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
        },
        {
            key = "c",
            mods = "LEADER",
            description = "Close additional panes",
            action = wezterm.action_callback(function(win, pane)
                local tab = win:active_tab()
                for _, p in ipairs(tab:panes()) do
                    if p:pane_id() ~= pane:pane_id() then
                        p:activate()
                        win:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, p)
                    end
                end
            end),
        },
        {
            key = "d",
            mods = "LEADER",
            action = wezterm.action.ShowDebugOverlay
        },
        {
            key = "n",
            mods = "LEADER",
            action = wezterm.action.PromptInputLine {
                description = wezterm.format {
                    { Attribute = { Intensity = "Bold" } },
                    { Foreground = { AnsiColor = "Fuchsia" } },
                    { Text = "Enter name for new tab" },
                },
                action = wezterm.action_callback(function(window, _, line)
                    if line then
                        for _, repo in ipairs(repos) do
                            local project = string.gsub(repo.path, "(.*jedrw/)(.*)", "%2")
                            if string.find(line, project) then
                                window:mux_window():spawn_tab({ cwd = repo.path })
                                window:active_tab():set_title(line)
                                return
                            end
                        end

                        window:mux_window():spawn_tab { cwd = wezterm.home_dir }
                        if line then
                            window:active_tab():set_title(line)
                        end
                    end
                end),
            },
        },
        {
            key = "p",
            mods = "LEADER",
            action = wezterm.action_callback(function(window, pane)
                repos = projects.get_repos(repos_dir)
                local choices = {}
                for _, repo in ipairs(repos) do
                    table.insert(
                        choices,
                        {
                            label = wezterm.format {
                                {
                                    Foreground = {
                                        AnsiColor = repo.changes and "Yellow" or "Green"
                                    },
                                },
                                { Text = repo.path },
                            },
                            id = repo.path,
                        }
                    )
                end

                window:perform_action(
                    wezterm.action.InputSelector {
                        title = "Projects",
                        choices = choices,
                        fuzzy = true,
                        fuzzy_description = "Search: ",
                        action = wezterm.action_callback(function(window, _, id, _)
                            local path = id
                            -- "label" may be empty if nothing was selected. Don't bother doing anything
                            -- when that happens.
                            if not path then
                                return
                            end

                            -- Check for a tab with a matching title and switch to it if found
                            local project = string.gsub(path, "(.*jedrw/)(.*)", "%2")
                            for _, tab in ipairs(window:mux_window():tabs()) do
                                if tab:get_title() == project then
                                    tab:activate()
                                    return
                                end
                            end

                            -- Else create a new tab for project with cwd of project path
                            local tab, _, _ = window:mux_window():spawn_tab { cwd = path }
                            tab:set_title(project)
                        end),
                    },
                    pane
                )
            end
            ),
        },
        {
            key = "s",
            mods = "LEADER",
            action = wezterm.action_callback(function(window, pane)
                local choices = {}
                for _, domain in ipairs(wezterm.default_ssh_domains()) do
                    if not string.find(domain.name, "SSHMUX") then
                        local hostname = string.gsub(domain.name, "(SSH:)(.*)", "%2")
                        table.insert(
                            choices,
                            {
                                label = wezterm.format {
                                    { Text = hostname },
                                },
                                id = hostname
                            }
                        )
                    end
                end

                window:perform_action(
                    wezterm.action.InputSelector {
                        title = "SSH",
                        choices = choices,
                        fuzzy = true,
                        fuzzy_description = "Search SSH connections: ",
                        action = wezterm.action_callback(function(window, _, id, _)
                            local hostname = id
                            -- "label" may be empty if nothing was selected. Don't bother doing anything
                            -- when that happens.
                            if not hostname then
                                return
                            end

                            -- Else create a new tab for project with cwd of project path
                            local tab, _, _ = window:mux_window():spawn_tab { args = { "ssh", hostname } }
                            tab:set_title(hostname)
                        end),
                    },
                    pane
                )
            end
            ),
        },
        {
            key = "t",
            mods = "LEADER",
            action = wezterm.action.ShowLauncherArgs {
                flags = "FUZZY|TABS",
            },
        },
    }

    for i = 1, 9 do
        -- LEADER + number to activate that tab
        table.insert(keys, {
            key = tostring(i),
            mods = "LEADER",
            action = wezterm.action.ActivateTab(i - 1),
        })
    end

    -- Rather than emitting fancy composed characters when alt is pressed, treat the
    -- input more like old school ascii with ALT held down
    config.send_composed_key_when_left_alt_is_pressed = false
    config.send_composed_key_when_right_alt_is_pressed = false

    config.keys = keys
    config.mouse_bindings = {
        -- Ctrl-click will open the link under the mouse cursor
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    }
end

return module
