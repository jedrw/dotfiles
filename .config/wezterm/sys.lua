local module = {}
local wezterm = require 'wezterm'

function module.is_os (name)
    return wezterm.target_triple:find(name) ~= nil
end

module.is_linux = module.is_os("linux")
module.is_macos = module.is_os("darwin")

return module
