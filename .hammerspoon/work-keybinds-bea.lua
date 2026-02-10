-- format rows to newline
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

-- downpayment format
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
