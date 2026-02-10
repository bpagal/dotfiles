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
