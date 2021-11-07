#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global ARROW_SCROLL_UP_X = 1130
global ARROW_SCROLL_UP_Y = 115
global ARROW_SCROLL_DOWN_X = 1130
global ARROW_SCROLL_DOWN_Y = 525

global LEFT_COLUMN_X = 1100
global RIGHT_COLUMN_Y = 1160

ScrollUp() {
	MouseMove, %ARROW_SCROLL_UP_X%, %ARROW_SCROLL_UP_Y%, 0

	Click, %ARROW_SCROLL_UP_X%, %ARROW_SCROLL_UP_Y%
	Click, %ARROW_SCROLL_UP_X%, %ARROW_SCROLL_UP_Y%
	Click, %ARROW_SCROLL_UP_X%, %ARROW_SCROLL_UP_Y%
}

ScrollDown() {
	MouseMove, %ARROW_SCROLL_DOWN_X%, %ARROW_SCROLL_DOWN_Y%, 0

	Click, %ARROW_SCROLL_DOWN_X%, %ARROW_SCROLL_DOWN_Y%
	Click, %ARROW_SCROLL_DOWN_X%, %ARROW_SCROLL_DOWN_Y%
	Click, %ARROW_SCROLL_DOWN_X%, %ARROW_SCROLL_DOWN_Y%
}

ClickAndBack(x, y) {
	MouseGetPos, oldX, oldY

	MouseMove, %x%, %y%, 0	
	Send {LButton down}
	Send {LButton up}
	
	
	MouseMove, %oldX%, %oldY%, 0
}

BTD5SelectTower(dir, x, y) {
	MouseGetPos, oldX, oldY
	
	if (dir == "up") {
		ScrollUp()
	} else {
		ScrollDown()
	}

	MouseMove, %x%, %y%, 0
	Send {LButton down}
	MouseMove, %oldX%, %oldY%, 0
}

; Upgrade left
#IfWinActive Bloons TD5
z::
	Send, {,}
return

; Upgrade right
#IfWinActive Bloons TD5
x::
	Send, .
return

; Ability 1
#IfWinActive Bloons TD5
1::
	ClickAndBack(215, 610)
return

; Dart monkey
#IfWinActive Bloons TD5
q::
	BTD5SelectTower("up", 1100, 160)
return

; Wizard
#IfWinActive Bloons TD5
w::
	BTD5SelectTower("up", 1160, 475)
return

; Super monkey
#IfWinActive Bloons TD5
g::
	BTD5SelectTower("up", 1100, 475)
return

; Dartling gunner
#IfWinActive Bloons TD5
d::
	BTD5SelectTower("down", 1160, 290)
return

; Farm
#IfWinActive Bloons TD5
f::
	BTD5SelectTower("down", 1160, 225)
return

; Spike factory
#IfWinActive Bloons TD5
s::
	BTD5SelectTower("down", 1100, 350)
return

; Yellow Submarine
#IfWinActive Bloons TD5
y::
	BTD5SelectTower("down", 1100, 475)
return

; Bloonchipper
#IfWinActive Bloons TD5
b::
	BTD5SelectTower("down", 1150, 415)
return

; Debug
#IfWinActive Bloons TD5
c::
	MouseGetPos, x, y
	MsgBox, %x%x%y%
return