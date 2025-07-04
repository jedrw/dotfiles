local wezterm = require('wezterm')
local module = {}

---@param path string
---@return boolean
local function is_dir(path)
    local ok, entries = pcall(wezterm.read_dir, path)
    return ok and type(entries) == "table"
end

---@param path string
---@return boolean
local function is_git_repo(path)
    local dirs = wezterm.read_dir(path)
    for _, dir in ipairs(dirs) do
        if string.match(dir, "%.git") then
            return true
        end
    end
    return false
end

---@param path string
---@return boolean
local function has_uncommitted_changes(path)
    local command = "git -C " .. path .. " status --porcelain"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    -- If `result` is not empty, there are uncommitted changes
    return result ~= ""
end

---@class Repo
---@field path string The path to the file or directory.
---@field changes boolean Whether there are uncommitted changes.

---@param start_dir string
local function recursively_find_git_repos(start_dir)
    ---@type Repo[]
    local repos = {}
    ---@type string[]
    local stack = { start_dir }
    while stack do
        local dir = table.remove(stack)
        if dir == nil then
            break
        end

        if is_git_repo(dir) then
            table.insert(repos, { path = dir, changes = has_uncommitted_changes(dir) })
        else
            local sub_dirs = wezterm.read_dir(dir)
            for _, sub_dir in ipairs(sub_dirs) do
                if is_dir(sub_dir) then
                    table.insert(stack, sub_dir)
                end
            end
        end
    end

    return repos
end

---@param a Repo
---@param b Repo
---@return boolean
local function sort_alphabetical(a, b)
    return a.path:lower() < b.path:lower()
end

---@param repos_dir string
---@return Repo[]
function module.get_repos(repos_dir)
    local repos = recursively_find_git_repos(repos_dir)
    table.sort(repos, sort_alphabetical)
    return repos
end

return module
