local alt = { "alt" }

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

-- Define app bindings
-- keyboard row 1
bindAppHotkey("1", "Brave Browser")
bindAppHotkey("2", "Firefox")
bindAppHotkey("3", "Telegram")
-- keyboard row 2
bindAppHotkey("Q", "Microsoft Excel")
bindAppHotkey("W", "Microsoft PowerPoint")
bindAppHotkey("E", "Google Chrome")
bindAppHotkey("S", "Viber")
bindAppHotkey("D", "Notes")

-- Move window and mouse to other monitor using Option + Shift + Tab
hs.hotkey.bind({ "alt", "shift" }, "tab", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local currentScreen = win:screen()
	local otherScreen = currentScreen:next()

	if otherScreen then
		-- Move window
		win:moveToScreen(otherScreen)

		-- Move mouse to center of the new window
		local frame = win:frame()
		local center = hs.geometry.rectMidPoint(frame)
		hs.mouse.absolutePosition(center)
	end
end)
-- Switch between windows of the current application
-- Bind Alt+A to cycle through windows

local function switchToNextWindow()
	local currentApp = hs.application.frontmostApplication()

	if not currentApp then
		return
	end

	-- Get all windows of the current application
	local windows = currentApp:allWindows()

	-- Filter out minimized windows and keep only standard windows
	local visibleWindows = {}
	for _, win in ipairs(windows) do
		if win:isStandard() and not win:isMinimized() then
			table.insert(visibleWindows, win)
		end
	end

	-- Need at least 2 windows to switch
	if #visibleWindows < 2 then
		return
	end

	-- Sort windows by ID for consistent ordering
	table.sort(visibleWindows, function(a, b)
		return a:id() < b:id()
	end)

	-- Find the currently focused window
	local focusedWindow = hs.window.focusedWindow()
	local currentIndex = nil

	for i, win in ipairs(visibleWindows) do
		if win:id() == focusedWindow:id() then
			currentIndex = i
			break
		end
	end

	-- If we couldn't find current window, start from first
	if not currentIndex then
		currentIndex = 1
	end

	-- Get next window (cycle back to first if at end)
	local nextIndex = (currentIndex % #visibleWindows) + 1
	local nextWindow = visibleWindows[nextIndex]

	-- Focus the next window
	nextWindow:focus()
end

-- Bind Alt+A to switch windows
hs.hotkey.bind({ "alt" }, "A", switchToNextWindow)

-- Alt + H: Tile window to left half
hs.hotkey.bind({ "alt" }, "H", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local screen = win:screen()
	local frame = screen:frame()
	win:setFrame({ x = frame.x, y = frame.y, w = frame.w / 2, h = frame.h })
end)

-- Alt + L: Tile window to right half
hs.hotkey.bind({ "alt" }, "L", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local screen = win:screen()
	local frame = screen:frame()
	win:setFrame({
		x = frame.x + frame.w / 2,
		y = frame.y,
		w = frame.w / 2,
		h = frame.h,
	})
end)

-- Alt + M: Maximize window (full screen, not macOS fullscreen)
hs.hotkey.bind({ "alt" }, "M", function()
	local win = hs.window.focusedWindow()
	if win then
		win:maximize()
	end
end)

-- Browser tab navigation for Firefox and Brave
-- Alt+Z = Previous tab
-- Alt+X = Next tab

-- List of supported browsers
local browsers = {
	"Firefox",
	"Brave Browser",
}

-- Function to check if current app is a browser
local function isCurrentAppBrowser()
	local currentApp = hs.application.frontmostApplication()
	local appName = currentApp:name()

	for _, browser in ipairs(browsers) do
		if appName == browser then
			return true
		end
	end
	return false
end

-- Alt+Z - Previous tab (Ctrl+Shift+Tab)
hs.hotkey.bind({ "alt" }, "Z", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl", "shift" }, "tab")
	end
end)

-- Alt+X - Next tab (Ctrl+Tab)
hs.hotkey.bind({ "alt" }, "X", function()
	if isCurrentAppBrowser() then
		hs.eventtap.keyStroke({ "ctrl" }, "tab")
	end
end)

hs.hotkey.bind({ "alt", "cmd" }, "A", function()
	local original = hs.pasteboard.getContents()
	if not original or not original:find("\t") then
		return
	end

	local formatted = original:gsub("\t", "\n")

	hs.pasteboard.setContents(formatted)
	hs.eventtap.keyStroke({ "cmd" }, "v")

	-- Restore clipboard quietly
	hs.timer.doAfter(0.15, function()
		hs.pasteboard.setContents(original)
	end)
end)

hs.hotkey.bind({ "alt", "cmd" }, "S", function()
	local clipboard = hs.pasteboard.getContents()
	if not clipboard or clipboard == "" then
		return
	end

	-- Split by spaces or tabs
	local numbers = {}
	for num in clipboard:gmatch("[^%s]+") do
		table.insert(numbers, num)
	end

	-- Labels in order
	local labels = { "DP", "6 MONS", "12 MONS", "18 MONS", "24 MONS", "30 MONS", "36 MONS" }

	-- Build output lines dynamically
	local lines = {}
	for i = 1, math.min(#numbers, #labels) do
		table.insert(lines, labels[i] .. ": " .. numbers[i])
	end

	-- Paste into current input
	local output = table.concat(lines, "\n")
	hs.pasteboard.setContents(output)
	hs.eventtap.keyStroke({ "cmd" }, "v")

	-- Restore original clipboard silently
	hs.timer.doAfter(0.15, function()
		hs.pasteboard.setContents(clipboard)
	end)
end)
