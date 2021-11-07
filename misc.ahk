#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Event ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#EscapeChar \
#MaxHotkeysPerInterval 10000
#InstallKeybdHook

; Includes anywhere mode
SetTitleMatchMode 2

; Set coordinates relative to the top left of screen vs window
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; ctrl+alt+} combinator to immediately send `
^!}::
	Send, {Text}`
return

; ctrl+alt+{ combinator to immediately send ^
^!{::
	Send, {Text}^
return

; Ctrl+Space to set the current window always on top
; Useful e.g. with VLC to play in a corner while doing something else
^SPACE::
	WinSet, AlwaysOnTop, Toggle, A
return

; Alt+Space to toggle borderless window fullscreen on any app
; Use case: Some apps by taking control of the frame buffer don't let you alt+tab if they freeze up
; By using borderless windowed instead, you can have apps that freeze up but don't stop you from focusing elsewhere
; #UseHook On
!SPACE::
	WinGet, TempWindowID, ID, A
	
	if (WindowID != TempWindowID) {
		WindowID := TempWindowID
		WindowState := 0
	}
	
	if (WindowState != 1) {
		WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
		WinSet, Style, -0xC40000, ahk_id %WindowID%
		WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
		
		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
		WinHide ahk_class Shell_TrayWnd
		WinHide Start ahk_class Button
	} else {
		WinSet, Style, +0xC40000, ahk_id %WindowID%
		WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
		
		; Show the task bar again
		WinShow ahk_class Shell_TrayWnd
		WinShow Start ahk_class Button
	}
	
	WindowState := !WindowState
return

; Disable F1 completely (help key, File Explorer, Koikatsu)
F1::
	; Do nothing
return

; VLC Screenshot and next frame
!+e::
	Send, {Shift down}s{Shift up}
	Sleep, 150
	Send, {e}
return

+^d::
	Click, 1105 58
	Sleep, 100
	Click, 131 743

	Sleep, 300
	Send, {Up}{Delete}

	Sleep, 750
	Click, 131 743
	Click, 1150 750
	Click, 1170 620

	Sleep, 1000
	Click, 1222 332
	
	Sleep, 13000
	Click, 670 440
	
	Sleep, 1000
	Click, 680 370
	
	Sleep, 1000
	Click, 444 210
	
	Sleep, 1000
	Click, 680 360
	
	Sleep, 3000
	Click, 680 360
	
	Sleep, 1000
	Click, 444 210
	
	Sleep, 3000
	Click, 680 360
return

#IfWinActive DELTARUNE
a::
	Send, {z down}
return

#IfWinActive DELTARUNE
a UP::
	Send, {z up}
return

#IfWinActive DELTARUNE
s::
	Send, {Enter down}{Enter up}
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
