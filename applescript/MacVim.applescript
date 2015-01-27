tell application "Finder"
    set procs to name of processes
    if "MacVim" is not in procs then
        tell application "MacVim" to activate
    else 
        tell application "MacVim" to activate
    end if
end tell
