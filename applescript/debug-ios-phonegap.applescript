tell application "Finder"
    set procs to name of processes
    if "Safari" is not in procs then
        tell application "Safari" to activate
    else 
        tell application "Safari" to activate
        tell application "System Events"
            tell process "Safari"
                 tell menu bar item "Develop" of menu bar 1
                      click
                      tell menu item "iOS Simulator" of menu 1
                           click
                           click menu item 2 of menu 1
                      end tell
                 end tell
            end tell
        end tell
    end if
end tell
