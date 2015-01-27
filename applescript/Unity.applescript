tell application "Finder"
    set procs to name of processes
    if "Unity" is not in procs then
        tell application "Unity" to activate
    else 
        tell application "Unity" to activate
    end if
end tell
