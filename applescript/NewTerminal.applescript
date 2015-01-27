tell application "iTerm" to activate
tell application "System Events"
    tell process "iTerm"
        click menu item "New Window" of menu "Shell" of menu bar 1
    end tell
end tell
