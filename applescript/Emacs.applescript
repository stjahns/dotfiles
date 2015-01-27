tell application "Finder"
    set procs to name of processes
    if "Emacs" is not in procs then
        tell application "Emacs" to activate
    else 
        tell application "Emacs" to activate
    end if
end tell
