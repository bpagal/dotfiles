local mouse = require("utils.mouse")

local M = {}
local alt = { "alt" }

-- App bindings with smart mouse follow
function M.bindAppHotkey(key, appName)
	hs.hotkey.bind(alt, key, function()
		hs.application.launchOrFocus(appName)
		mouse.moveMouseToApp(appName)
	end)
end

return M
