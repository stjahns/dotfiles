;;
;; swm.ahk - The Steve Window Manager
;;

;;
;; Screen - handle for a Screen with a bunch of windows
;;
class Screen
{
    Windows := {}
    Name := ""
    TopLimit := 0
    LeftLimit := 0
    LastActiveWindow := 0
    
    __New(aName)
    {
        this.Name := aName
    }
    
    GetWindowArray()
    {
        array := []
        For id, window In this.Windows
        {
            array.Insert(window)
        }
        return array
    }
    
    DebugString[]
    {
        get 
        {
            msg := this.Name . ":`r"
            For i, window In this.Windows
            {
                msg := msg . "`t" . window.Id . " : " . window.Name . "`r"
            }
            return msg
        }
    }
    
    Activate()
    {
        if this.LastActiveWindow
            this.LastActiveWindow.Activate()
        else
            this.GetWindowArray()[1].Activate()
    }
}

;;
;; Window - handle for a window with an Id and a Name
;;
class SWMWindow 
{
    Id := ""
    PositionX := 0
    PositionY := 0
    
    __New(id)
    {
        this.Id := id
    }
    
    Name[]
    {
        get
        {
            WinGetTitle, aName, % "ahk_id " this.id
            return aName
        }
    }

    Class[]
    {
        get
        {
            WinGetClass, aClass, % "ahk_id " this.id
            return aClass
        }
    }

    Activate()
    {
        WinActivate, % "ahk_id " this.Id
    }

    ShouldTrack()
    {
	WindowBlacklist := "(SwitchingWindow)|(DummyWindow)|(emacs)|(Program Manager)|(WindowList)"
        name := this.Name
        if !name || name == "" || RegExMatch(name, WindowBlacklist) != 0
        {
            return False
        }
        else
        {
            return True
        }
    }
}

;;
;; Display the contents of each screen in a MsgBox
;;
SWMDebugScreens()
{
    global Screens
    global Windows

    DebugMsg := ""

    For screenIndex, screen In Screens
    {
        screen.Foo()
        DebugMsg .= screen.DebugString
    }
    
    DebugMsg .= "`rAll Windows:`r"
    
    For windowId, window In Windows
    {
        DebugMsg .= windowId . " : " . window.Name . "`r"
    } 
    
    MsgBox %DebugMsg%
}

;;
;; Initialize the array of Screen handles according to yer current
;; monitor configuration
;;
;; TODO - maybe figure out monitor configuration automatically?
;;
SWMInit() 
{
    global Screens
    global Windows

    Screens := [new Screen("LEFT"), new Screen("CENTER"), new Screen("RIGHT")]
    Windows := []
}


SWMRefreshWindowList()
{
    global Windows ; Map of window id to SWMWindow 

    For id, window In Windows
    {
        window.present := False
    }

    WinGet allWindows, List
    Loop, %allWindows%
    {
        windowId := allWindows%A_Index%
        window := Windows[windowId]
        
        if !window 
        {
            window := new SWMWindow(windowId)
            if Window.ShouldTrack()
                Windows[windowId] := window
        }

        window.present := True
    }

    For id, window In Windows
    {
        if !window.present
        {
            Windows.Remove(id)
            window.Screen.Windows.Remove(id)
        }
    }
}

;; FIXME dumbbb
SWMScreenForWindow(windowId)
{
    global Screens

    WinGetPos, xPos, yPos,,, % "ahk_id " windowId
    
    ;; X coords of maximized window positions..
    CenterScreenLeft := -11 
    RightScreenLeft := 5743
    
    ActiveScreen := Screens[1]
    if (Xpos >= RightScreenLeft) 
    {
        ActiveScreen := Screens[3]
    } 
    else if (Xpos >= CenterScreenLeft) 
    {
        ActiveScreen := Screens[2]
    }
    
    return ActiveScreen
}

;;
;; Updates the screen containers according to what windows actually
;; exist and where
;;
SWMRefreshScreens() 
{
    global Screens
    global Windows
    
    if !Screens || !Windows
    {
        SWMInit()
    }
    
    SWMRefreshWindowList()
    
    ;; For each window, set the current screen
    For id, window in Windows
    {
        screen := SWMScreenForWindow(id)
        if (window.Screen != screen)
        {
            window.Screen.Windows.Remove(id)
            screen.Windows[id] := window
            window.Screen := screen
        }
    }
    
    return
}

SWMGetActiveWindow()
{
    global Windows
    WinGet, id, ID, A
    return Windows[id]
}

SWMCycleScreenWindows(indexDiff)
{
    currentWindow := SWMGetActiveWindow()
    screen := currentWindow.Screen
    windowArray := screen.GetWindowArray()

    currentIndex := -1
    maxIndex := 0
    For index, window In windowArray
    {
        if window.Id == currentWindow.Id
        {
            currentIndex := index
        }
        maxindex := index
    }

    ;; Dude I can't remember how to maths :(
    nextIndex := Abs(Mod(currentIndex - 1 + indexDiff, maxIndex)) + 1
    if currentIndex - 1 + indexDiff < 0
        nextIndex := maxIndex 
    
    nextWindow := windowArray[nextIndex]
    nextWindow.Activate()

    screen.LastActiveWindow := nextWindow
    return
}

SWMSwitchScreen(indexDiff)
{
    global Screens

    currentWindow := SWMGetActiveWindow()
    currentScreen := currentWindow.Screen


    For index, screen In Screens
    {
        if currentScreen.Name == screen.Name
            screenIndex := index
        screenCount := index
    }

    ;; Dude I can't remember how to maths :(
    nextIndex := Abs(Mod(screenIndex - 1 + indexDiff, screenCount)) + 1
    if screenIndex - 1 + indexDiff < 0
        nextIndex := screenCount

    nextScreen := Screens[nextIndex]
    nextScreen.Activate()
    return
}
    
SWMGetWindows()
{
    global Windows
    return Windows
}
    
SWMFindWindowUpdate()
{
WINDOWSEARCH:
    GuiControlGet, SearchText,, Edit1
    LV_Delete()

    For id, window In SWMGetWindows()
    {
        name := window.Name
        class := window.Class
        if RegExMatch(name, "i)" . SearchText) != 0  || RegexMatch(class, "i)" . SearchText)
        {
            LV_Add("", name, id)
            IfWinExist, ahk_id %id%
                WinSet, Transparent, 255
        }
        else
        {
            IfWinExist, ahk_id %id%
                WinSet, Transparent, 50
        }
    }

    return

WINDOWSELECT:
    GuiControlGet, SearchText,, Edit1
    
    SWMCloseWindows()

    if SearchText
    {
        For id, window In SWMGetWindows()
        {
            ;; activate the first one!
            name := window.Name
            class := window.Class
            if RegExMatch(name, "i)" . SearchText) != 0  || RegexMatch(class, "i)" . SearchText)
            {
                Window.Activate()
                return
            }
        }
    }

    return
}

SWMFindWindow()
{
    global searchKey

    SWMCloseWindows()
    SWMRefreshScreens() 
    
    searchKey := ""

    Gui, +AlwaysOnTop -SysMenu +Owner -Caption
    Gui, font, FFFFFFF, Verdana
    Gui, Add, Edit, w280 gWINDOWSEARCH
    Gui, Add, ListView, w280, Window

    Gui, Add, Button, x-10 y-10 w1 h1 +default gWindowSelect
    
    Gui, Color, 333333, 
    
    Gui, Show, x1700 y1000 w300 h130, WindowList
    GuiControl, Focus, Edit1
    ;Gui, +AlwaysOnTop +Disabled -SysMenu +Owner -Caption
    ;Gui, Add, Text,, Hello
    ;Gui, Show, NoActivate x-1000 y800 w1000 h25, WindowList
    return

}



SWMCloseWindows()
{
    Gui, Destroy
    For id, window In SWMGetWindows()
    {
        IfWinExist, ahk_id %id%
            WinSet, Transparent, 255
    }
}



SWMWindowLists()
{
    
    Gui, +AlwaysOnTop +Disabled -SysMenu +Owner -Caption
    Gui, Add, Text,, Hello
    Gui, Show, NoActivate x0 y0 w3000 h25, WindowList

    Gui, 2:+AlwaysOnTop +Disabled -SysMenu +Owner -Caption
    Gui, 2:Add, Text,, Hello
    Gui, 2:Show, NoActivate x-2520 y840 w1680 h25, WindowList
    return

}

;SWMWindowLists()

