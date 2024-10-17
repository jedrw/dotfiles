local wezterm = require('wezterm')
local module = {}

local function is_dir(path)
    local f = io.open(path, "r")
    local _, _, code = f:read(1)
    f:close()
    return code == 21
end

local function is_git_repo(path)
    local f=io.open(path .. "/.git","r")
    if f~=nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function recursively_find_git_repos(start_dir)
    local repos = {}
    local stack = { start_dir }
    while stack do
        local dir = table.remove(stack, 1)
        if dir == nil then
            break
        end

        if is_git_repo(dir) then
            table.insert(repos, dir)
        else
            local sub_dirs = wezterm.read_dir(dir)
            for _, sub_dir in ipairs(sub_dirs) do
                if is_dir(sub_dir) then
                    table.insert(stack, 1, sub_dir)
                end
            end
        end
    end

    return repos
end

local function sort_alphabetical(a, b)
    return a:lower() < b:lower()
end

function module.get_repos(repos_dir)
    local repos = recursively_find_git_repos(repos_dir)
    table.sort(repos, sort_alphabetical)
    return repos
end

return module
