tell application "Finder"
    set procs to name of processes
    if "Eclipse" is not in procs then
        tell application "Eclipse" to activate
    else 
        tell application "Eclipse" to activate
    end if
end tell
