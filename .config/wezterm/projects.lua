local wezterm = require('wezterm')
local module = {}

local function is_git_repo(dir)
    for _, f in ipairs(wezterm.read_dir(dir)) do
        local filename = string.gsub(f, "(.*/)(.*)", "%2")
        if filename == ".git" then
            return true
        end
    end

    return false
end

local function recursively_find_git_repos(path)
    for _, dir in ipairs(wezterm.read_dir(path)) do
        if is_git_repo(dir) then
            local project_name = string.gsub(dir, "(.*/)(.*)", "%2")
            Repos[project_name] = dir
        else
            recursively_find_git_repos(dir)
        end
    end
end

local function get_repos()
    local repos_dir = wezterm.home_dir .. "/repos"
    Repos = {}
    recursively_find_git_repos(repos_dir)
    return Repos
end

function module.choose_project()
    local repos = get_repos()
    local choices = {}
    for project, path in pairs(repos) do
        table.insert(choices, { label = project, id = path })
    end

    return wezterm.action.InputSelector {
        title = "Projects",
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(window, pane, id, label)
            -- "label" may be empty if nothing was selected. Don't bother doing anything
            -- when that happens.
            if not label then
                return
            end

            local project = label
            local path = id
            -- Check for a tab with a matching title and switch to it if found
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
    }
end

return module
