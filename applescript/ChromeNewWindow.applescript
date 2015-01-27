tell application "Finder"
    set procs to name of processes
    if "Google Chrome" is not in procs then
        tell application "Google Chrome" to activate
    else 
        tell application "Google Chrome" to activate
        tell application "System Events"
            tell process "Google Chrome"
                click menu item "New Window" of menu "File" of menu bar 1
            end tell
        end tell
    end if
end tell
