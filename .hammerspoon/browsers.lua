local browsers = {
	"Firefox",
	"Brave Browser",
	"Google Chrome",
	"Safari",
}

-- Function to check if current app is a browser
local function isCurrentAppBrowser()
	local currentApp = hs.application.frontmostApplication()
	if not currentApp then
		return false
	end

	local appName = currentApp:name()

	for _, browser in ipairs(browsers) do
		if appName == browser then
			return true
		end
	end
	return false
end

-- Alt + Z - Previous tab
hs.hotkey.bind({ "alt" }, "Z", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl", "shift" }, "tab")
	end
end)

-- Alt + X - Next tab
hs.hotkey.bind({ "alt" }, "X", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl" }, "tab")
	end
end)

-- Alt + Shift + X - Move tab to previous
hs.hotkey.bind({ "alt", "shift" }, "Z", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl", "shift" }, "pageup", 0)
	end
end)

-- Alt + Shift + X - Move tab to next
hs.hotkey.bind({ "alt", "shift" }, "X", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl", "shift" }, "pagedown", 0)
	end
end)

-- Alt + Shift + A - go back one page
hs.hotkey.bind({ "alt", "shift" }, "A", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "cmd" }, "left")
	end
end)

-- Alt + Shift + S - go forward one page
hs.hotkey.bind({ "alt", "shift" }, "S", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "cmd" }, "right")
	end
end)
