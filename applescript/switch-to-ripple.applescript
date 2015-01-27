tell application "System Events"
    tell (last process whose name is "java")
      set frontmost to true
    end tell
end tell