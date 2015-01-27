tell application "Finder"
    set procs to name of processes
    if "Xcode" is not in procs then
        tell application "Xcode" to activate
    else 
        tell application "Xcode" to activate
        tell application "System Events"
            tell process "Xcode"
                 tell menu bar item "File" of menu bar 1
                      click
                      tell menu item "Open Recent" of menu 1
                           click
                           tell menu item 1 of menu 1
                                click
                           end tell
                      end tell
                 end tell
                 tell menu bar item "Product" of menu bar 1
                      click
                      tell menu item "Run" of menu 1
                           click
                      end tell
                 end tell
            end tell
        end tell
    end if
end tell
