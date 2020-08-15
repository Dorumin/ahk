#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Event ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#EscapeChar \
#MaxHotkeysPerInterval 10000
#InstallKeybdHook
SetTitleMatchMode 2

F4::
return

^u::
	Send, i
return
+^u::
	Send, I
return

^j::
	Send, k
return
+^j::
	Send, K
return

^m::
	Send, {,}
return
+^m::
	Send, {;}
return

^7::
	Send, 8
return
+^7::
	Send, {(}
return

!^j::
	Send, {Ctrl down}{Shift down}i{Shift up}{Ctrl up}
return

^´::
	Send, {+}
return

+^´::
	Send, ~
return

; Discord shittiness
#IfWinActive Discord
^e::
	; do nothing
return

#IfWinActive Discord
^r::
	; do nothing
return

#IfWinActive Discord
^p::
	; do nothing
return

:?:ti::it

AutoPlaceMouseX := 0
AutoPlaceMouseY := 0
AutoPlace := false

#IfWinActive SPORE
~^LButton::
	global AutoPlace, AutoPlaceMouseX, AutoPlaceMouseY
	AutoPlace := true
	MouseGetPos, AutoPlaceMouseX, AutoPlaceMouseY
return

#IfWinActive SPORE
~^LButton Up::
	global AutoPlace, AutoPlaceMouseX, AutoPlaceMouseY
	if (AutoPlace) {
		SendMode, Event
		MouseGetPos, AutoPlaceTargetX, AutoPlaceTargetY
		AutoPlace := false

		Loop, 7 {
			MouseMove, %AutoPlaceMouseX%, %AutoPlaceMouseY%, 2
			Sleep, 30
			Send, {LButton down}
			Sleep, 30
			MouseMove, %AutoPlaceTargetX%, %AutoPlaceTargetY%, 2
			Sleep, 30
			Send, {LButton up}
			Sleep, 30
		}
	}
return

BMCClicking := 0
BMCIncrement := 0


#IfWinActive Bloons Monkey City
z::
	Send, {,}
return

#IfWinActive Bloons Monkey City
x::
	Send, .
return

#IfWinActive Bloons Monkey City
^!g::
	if (BMCClicking == 1) {
		BMCClicking = 0
		BMCIncrement = 0
	} else {
		BMCClicking = 1
		Loop {
			if (!WinActive("Bloons Monkey City")) {
				BMCClicking = 0
				BMCIncrement = 180
				break
			}

			if (BMCIncrement != -1) {
				BMCIncrement -= 1
			} else {
				BMCIncrement = 180
				Click, 50, 270
				Click, 160, 270
				Click, 270, 270
				Click, 380, 270
				Click, 490, 270
				Click, 600, 270
			}

			Sleep, 10000
		}
	}
return

#IfWinActive Bloons Monkey City
1::
	Click, L, 200, 610, 0
return

MoveAndReturnMouse(x, y) {
	MouseGetPos, oldX, oldY
	MouseMove, %x%, %y%, 0

}

SelectTower(dir, x, y) {
	MouseGetPos, oldX, oldY

	if (dir == "down") {
		; MsgBox, down %dir%
		DragBottomUp()
	} else {
		; MsgBox, up %dir%
		DragTopDown()
	}

	MouseMove, %x%, %y%, 0
	Send {LButton down}
	MouseMove, %oldX%, %oldY%, 0
}

DragBottomUp() {
	MouseMove, 1130, 500, 0
	MouseClickDrag, Left, 1130, 500, 1130, 0, 3
	MouseMove, 1130, 500, 0
	MouseClickDrag, Left, 1130, 500, 1130, 0, 3
	; Send {LButton up}
	; Sleep, 50
	; Send {LButton down}

	; MouseMove, 1130, 510, 0
	; Send {LButton down}
	; MouseMove, 1130, 0, 0
	; Send {LButton up}
}

DragTopDown() {
	MouseMove, 1130, 150, 0
	MouseClickDrag, Left, 1130, 150, 1130, 760, 3
	MouseMove, 1130, 150, 0
	MouseClickDrag, Left, 1130, 150, 1130, 760, 3
}

; Wizard down 1150, 280
#IfWinActive Bloons Monkey City
w::
	SelectTower("down", 1150, 280)
return

; Engineer up 1150, 460
#IfWinActive Bloons Monkey City
e::
	SelectTower("up", 1150, 430)
return

; Spactory down 1100, 440
#IfWinActive Bloons Monkey City
s::
	SelectTower("up", 1100, 440)
return

; Spactory 1-4
#IfWinActive Bloons Monkey City
+s::
	SelectTower("up", 1100, 440)
	Send {LButton up}
	Send, {.}{.}{.}{.}{.}{.}{,}
return

; Dartling gun down 1150, 335
#IfWinActive Bloons Monkey City
d::
	SelectTower("down", 1150, 335)
return

; Farm down 1100, 340
#IfWinActive Bloons Monkey City
f::
	SelectTower("down", 1100, 340)
return

; Village up 1100, 380
#IfWinActive Bloons Monkey City
v::
	SelectTower("up", 1100, 380)
return

#IfWinActive Bloons Monkey City
h::
	MouseGetPos, oldX, oldY
	MsgBox, Pos(%oldX%, %oldY%)
return

; VLC Screenshot and next frame
!+e::
	Send, {Shift down}s{Shift up}
	Sleep, 150
	Send, {e}
return

; Map page down key to supr
PgDn::
	Send, {Delete}
return

^PgDn::
	Send, {Ctrl down}{Delete}{Ctrl up}
return

+PgDn::
	Send, {Shift down}{Delete}{Shift up}
return

; ctrl+alt+} combinator to immediately send `
^!}::
	Send, {Text}`
return

; ctrl+alt+{ combinator to immediately send ^
^!{::
	Send, {Text}^
return

; Disable F1 completely (help key, File Explorer, Koikatsu)
F1::return

; Ctrl+Space to set the current window always on top
^SPACE::  Winset, Alwaysontop, , A
