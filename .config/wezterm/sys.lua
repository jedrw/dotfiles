local module = {}
local wezterm = require 'wezterm'

module.is_os = function(name)
    return wezterm.target_triple:find(name) ~= nil
end

module.is_linux = module.is_os("linux")
module.is_macos = module.is_os("darwin")

return module
