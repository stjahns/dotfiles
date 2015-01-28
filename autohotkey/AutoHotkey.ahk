;; 
;; Remap:	SOMEKEY::OTHERKEY
;;
;; Modifiers:
;;		# - Windows
;;		! - Alt
;;		^ - Control
;;		+ - Shift

#include C:\Users\steve\Documents\swm.ahk

SetTitleMatchMode RegEx


^!r::Reload

Capslock::Esc

;;================================================================================
;; Specific App  Hotkeys
;;================================================================================

^!;::
	if WinExist("ahk_class Chrome_WidgetWin_1")
		WinActivate
	else
		Run Chrome
	return

^!n::
	Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
	return

;; Emacs
^!m::
	if WinExist("ahk_class Emacs")
		WinActivate
	else
		Run "C:\Users\steve\Desktop\emacs\bin\emacs"
	return

;; Visual Studio
^!,::
	if WinExist("^.*Microsoft Visual Studio$")
		WinActivate
	return

;; Unreal
^!u::
	if WinExist("ahk_class UnrealWindow")
		WinActivate
	return

;; Unity
^!.::
	if WinExist("ahk_class UnityContainerWndClass")
		WinActivate
	return

;; LWJGL Window
^!l::
	if WinExist("ahk_class LWJGL")
		WinActivate
	return

;; ConEmu
^!Enter::
	if WinExist("ahk_class VirtualConsoleClass")
		WinActivate
  else
    Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ConEmu\ConEmu (x64).lnk"
	return

;;================================================================================
;; SWM Bindings
;;================================================================================

!q::
    Send !{F4}
    return

!+h::
    Send #{Left}
    return

!+l::
    Send #{Right}
    return

!+Enter::
    Send #{Up}
    return

; #IfWinActive ahk_class Chrome_WidgetWin_1
; !+[::
;     Send ^ {}
; #IfWinActive

;#IfWinExist ahk_class AutoHotkeyGUI 
!Esc::
    SWMCloseWindows()
    return
;#IfWinExist
    
		
!p::SWMFindWindow()

!r::
	SWMRefreshScreens()
	SWMDebugScreens()
	return

!j::
	SWMRefreshScreens()
	SWMCycleScreenWindows(1)
	return
	
!k::
	SWMRefreshScreens()
	SWMCycleScreenWindows(-1)
	return

!h::
	SWMRefreshScreens()
	SWMSwitchScreen(-1)
	return

!l::
	SWMRefreshScreens()
	SWMSwitchScreen(1)
	return
