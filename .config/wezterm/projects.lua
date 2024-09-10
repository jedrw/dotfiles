local wezterm = require('wezterm')
local module = {}

function is_dir(path)
    local f = io.open(path, "r")
    local _, _, code = f:read(1)
    f:close()
    return code == 21
end

local function recursively_find_git_repos(path, repos, depth, max_depth)
    if depth >= max_depth then
        return
    end

    for _, dir in ipairs(wezterm.read_dir(path)) do
        if is_dir(dir) then
            if string.match(dir, "%.git") then
                table.insert(repos, path)
                break
            else
                recursively_find_git_repos(dir, repos, depth + 1, max_depth)
            end
        end
    end
end

local function sort_alphabetical(a, b)
    return a:lower() < b:lower()
end

function module.get_repos(repos_dir)
    local repos = {}
    recursively_find_git_repos(repos_dir, repos, 0, 4)
    table.sort(repos, sort_alphabetical)
    return repos
end

return module
