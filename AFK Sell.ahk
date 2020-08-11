#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

loopin := 0
clickin := 0

menu_delay = 2500
sell_delay = 350
sell_count = 15

$~Esc::
	loopin := 0
	clickin := 0
return

!f1::
	loopin := 1
	While loopin {
		Send, {Enter}
		Sleep 200
		if !loopin {
			break
		}
		Send, /shop food{Enter}
		Sleep, menu_delay
		Loop, %sell_count% {
			if !loopin {
				break
			}
			MouseClick, middle, 680, 230
			Sleep sell_delay
		}
		if !loopin {
			break
		}
		Send, {Esc}
		Sleep 200
		if !loopin {
			break
		}
		Send, {Enter}
		Sleep 200
		if !loopin {
			break
		}
		Send, /shop drops{Enter}
		Sleep, menu_delay
		Loop, %sell_count% {
			if !loopin {
				break
			}
			MouseClick, middle, 612, 280
			Sleep sell_delay
		}
		if !loopin {
			break
		}
		Send, {Esc}
		Sleep 200
	}
return

!f6::
	clickin := 1
	Loop {
		if !clickin {
			break
		}
		MouseClick, middle
		Sleep, 300
	}
return

!f7::
	MouseGetPos, xpos, ypos 
	MsgBox, The cursor is at X%xpos% Y%ypos%. 
return

!Numpad1::
	Send, {Enter}
	Sleep, 100
	Send, /is{Enter}
return

!NumpadEnd::
	Send, {Enter}
	Sleep, 100
	Send, /is{Enter}
return

!Numpad2::
	Send, {Enter}
	Sleep, 100
	Send, /shop{Enter}
return

!NumpadDown::
	Send, {Enter}
	Sleep, 100
	Send, /shop{Enter}
return