tell application "Finder"
	set procs to name of processes
	if "Google Chrome" is not in procs then
		tell application "Google Chrome" to activate
	else
		tell application "Google Chrome" to activate
	end if
end tell
