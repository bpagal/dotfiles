-- Utility: Move mouse to center of app's main window, only if cursor is on a different screen
local function moveMouseToApp(appName)
	local app = hs.appfinder.appFromName(appName)
	if not app then
		return
	end

	local win = app:mainWindow()
	if not win then
		return
	end

	local winScreen = win:screen()
	local mouseScreen = hs.mouse.getCurrentScreen()

	-- Only move mouse if on different screen
	if winScreen:id() ~= mouseScreen:id() then
		local frame = win:frame()
		local center = hs.geometry.rectMidPoint(frame)
		hs.mouse.absolutePosition(center)
	end
end

-- App bindings with smart mouse follow
local function bindAppHotkey(key, appName)
	hs.hotkey.bind(alt, key, function()
		hs.application.launchOrFocus(appName)
		moveMouseToApp(appName)
	end)
end
