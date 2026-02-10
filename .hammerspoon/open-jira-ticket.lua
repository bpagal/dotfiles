hs.hotkey.bind({ "alt", "shift" }, "J", function()
	-- Show text prompt and get the result
	local button, ticket = hs.dialog.textPrompt(
		"Open Jira Ticket", -- title
		"Enter ticket number:", -- informativeText
		"", -- default text
		"OK", -- OK button text
		"Cancel", -- Cancel button text
		false -- secure (password) input? false
	)

	if button == "OK" and ticket ~= "" then
		local url = "https://tickets.atlassian.net/browse/EETT-" .. ticket
		local script = [[
            tell application "Firefox"
                activate
                open location "]] .. url .. [["
            end tell
        ]]
		hs.osascript.applescript(script)
	end
end)
