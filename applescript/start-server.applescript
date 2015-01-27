-- Start iterm2 ...
tell application "iTerm"
activate
    set website to (make new terminal)
    tell website
         activate current session
         launch session "Default Session"

         -- split window - 3 on top, 2 on bottom
         tell i term application "System Events" to keystroke "D" using command down
         tell i term application "System Events" to keystroke "d" using command down
         tell i term application "System Events" to keystroke "K" using command down
         tell i term application "System Events" to keystroke "d" using command down
         tell i term application "System Events" to keystroke "d" using command down

         -- Zeus (top middle)
         tell i term application "System Events" to keystroke "[" using command down

         delay 1 
         
         tell the current session
              write text "cd ~/jobber/Jobber"
              write text "bundle exec zeus start"
         end tell

         delay 1 

         -- -- Website (top left)
         tell i term application "System Events" to keystroke "[" using command down

         delay 1 
         
         tell the current session
              write text "cd ~/jobber/website"
              write text "rails s"
         end tell

         delay 1

         -- -- Server (bottom left)
         tell i term application "System Events" to keystroke "[" using command down
         tell i term application "System Events" to keystroke "[" using command down

         delay 1

         tell the current session
              write text "cd ~/jobber/Jobber"
              write text "zeus s"
         end tell

         delay 1

         -- -- Background Worker (top right)
         tell i term application "System Events" to keystroke "[" using command down

         delay 1

         tell the current session
              write text "cd ~/jobber/Jobber"
              write text "bin/delayed_job -n 1 run"
         end tell

         delay 1


         -- -- Guard (bottom right)
         tell i term application "System Events" to keystroke "]" using command down
         tell i term application "System Events" to keystroke "]" using command down

         delay 1

         tell the current session
              write text "cd ~/jobber/Jobber"
              write text "guard"
         end tell
         
    end tell

end tell
