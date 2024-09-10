local wezterm = require('wezterm')
local sys = require("sys")
local module = {}

local function is_dir(path)
    local _, stdout, _ = wezterm.run_child_process(
        { "file", "--brief", path }
    )
    if string.match(stdout, "directory") then
        return true
    end
    return false
end


local function is_git_repo(dir)
    for _, f in ipairs(wezterm.read_dir(dir)) do
        local filename = string.gsub(f, "(.*/)(.*)", "%2")
        if filename == ".git" then
            return true
        end
    end
    return false
end

local function recursively_find_git_repos(path, repos)
    for _, dir in ipairs(wezterm.read_dir(path)) do
        if is_dir(dir) then
            if is_git_repo(dir) then
                table.insert(repos, dir)
            else
                recursively_find_git_repos(dir, repos)
            end
        end
    end
end

-- It was beautiful until it was run on a mac, now this...
local function get_repos_python(repos_dir)
    local success, stdout, _ = wezterm.run_child_process(
        { "python3", wezterm.config_dir .. "/get_repos.py", repos_dir }
    )
    if success then
        return wezterm.split_by_newlines(stdout)
    end
    return {}
end

local function get_repos(repos_dir)
    local repos = {}
    if sys.is_os("linux") then
        recursively_find_git_repos(repos_dir, repos)
    else
        repos = get_repos_python(repos_dir)
    end
    return repos
end

local function sort_alphabetical(a, b)
    return a:lower() < b:lower()
end

function module.choose_project()
    local repos_dir = wezterm.home_dir .. "/repos"
    local repos = get_repos(repos_dir)
    table.sort(repos, sort_alphabetical)
    local choices = {}
    for _, path in ipairs(repos) do
        local project = string.gsub(path, "(.*/)(.*)", "%2")
        table.insert(choices, { label = path, id = project })
    end

    return wezterm.action.InputSelector {
        title = "Projects",
        choices = choices,
        fuzzy = true,
        fuzzy_description = "Search: ",
        action = wezterm.action_callback(function(window, pane, project, path)
            -- "label" may be empty if nothing was selected. Don't bother doing anything
            -- when that happens.
            if not path then
                return
            end

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
