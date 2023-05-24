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

; REFERENCE:
; Ctrl = ^
; Shift = +
; Alt = !

; ctrl+alt+} combinator to immediately send `
^!}::
	Send, {Text}`
return

; ctrl+alt+{ combinator to immediately send ^
^!{::
	Send, {Text}^
return

^!P::
	Loop, 1000 {
		Click, 1000, 980
		Sleep, 1000
		Click, 210, 920 ; 110 / 210
		Sleep, 1000
		Click, 1100, 980
		Sleep, 305000
	}
return

;autoclicking := 0
;
;+h::
;	global autoclicking
;
;	autoclicking := 1
;
;	Loop, 300 {
;		if (autoclicking != 1) {
;			break
;		}
;
;		Send, {Click}
;	}
;return
;
;
; +h UP::
; 	global autoclicking
;
; 	autoclicking := 0
; return

; Alt+Ctrl+Space to set the current window always on top
; Useful e.g. with VLC to play in a corner while doing something else
+!T::
	WinGetTitle, TopName, A
	WinSet, AlwaysOnTop, Toggle, A
	TrayTip, Topped, %TopName%
return

; Ctrl+Shift+Space
^+SPACE::
    WinGet, TempWindowID, ID, A

	if (WindowID != TempWindowID) {
		WindowID := TempWindowID
		WindowState := 0
	}

	if (WindowState != 1) {
		WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
		WinSet, Style, -0xC40000, ahk_id %WindowID%
		; WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight

		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
		; WinHide ahk_class Shell_TrayWnd
		; WinHide Start ahk_class Button
	} else {
		WinSet, Style, +0xC40000, ahk_id %WindowID%
		; WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight

		; Show the task bar again
		; WinShow ahk_class Shell_TrayWnd
		; WinShow Start ahk_class Button
	}

	WindowState := !WindowState
return

; Alt+Space
!SPACE::
	WinGet, TempWindowID, ID, A
    ; MsgBox, last: %WindowID% cur: %TempWindowID%

	if (WindowID != TempWindowID) {
		WindowID := TempWindowID
		WindowState := 0
	}

	if (WindowState != 1) {
		WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
		WinSet, Style, -0xC40000, ahk_id %WindowID%
		WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight

		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
		; WinHide ahk_class Shell_TrayWnd
		WinHide Start ahk_class Button
	} else {
		WinSet, Style, +0xC40000, ahk_id %WindowID%
		WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight

		; Show the task bar again
		; WinShow ahk_class Shell_TrayWnd
		WinShow Start ahk_class Button
	}

	WindowState := !WindowState
return


; ; Alt+Space to toggle borderless window fullscreen on any app
; ; Use case: Some apps by taking control of the frame buffer don't let you alt+tab if they freeze up
; ; By using borderless windowed instead, you can have apps that freeze up but don't stop you from focusing elsewhere
; !SPACE::
; 	WinGet, TempWindowID, ID, A
;
; 	if (WindowID != TempWindowID) {
; 		WindowID := TempWindowID
; 		WindowState := 0
; 	}
;
; 	if (WindowState == 0) {
; 		WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
; 		WinSet, Style, -0xC40000, ahk_id %WindowID%
; 		WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
;
; 		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
; 		; WinHide ahk_class Shell_TrayWnd
; 		; WinHide Start ahk_class Button
;
; 		WindowState := 1
; 	} else if (WindowState == 1) {
; 		; WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
; 		WinSet, Style, -0xC40000, ahk_id %WindowID%
; 		WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
;
; 		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
; 		WinHide ahk_class Shell_TrayWnd
; 		WinHide Start ahk_class Button
;
; 		WindowState := 2
; 	} else if (WindowState == 2) {
; 		; WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
; 		WinSet, Style, -0xC40000, ahk_id %WindowID%
; 		ScreenHeightMinusTaskbar := A_ScreenHeight - 50
; 		WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, %ScreenHeightMinusTaskbar%
;
; 		; Hide Windows Task Bar and Start Button. (Remove the following two lines if you don't want that behaviour)
; 		WinShow ahk_class Shell_TrayWnd
; 		WinShow Start ahk_class Button
;
; 		WindowState := 3
; 	} else {
; 		WinSet, Style, +0xC40000, ahk_id %WindowID%
; 		WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
;
; 		; Show the task bar again
; 		WinShow ahk_class Shell_TrayWnd
; 		WinShow Start ahk_class Button
;
; 		WindowState := 0
; 	}
; return

; Disable F1 completely (help key, File Explorer, Koikatsu)
;F1::
;	; Do nothing
; return

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
#IfWinActive DiscordDISABLEDEMOJIPICKER
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
	MouseGetPos, oldX, oldY
	MouseMove, 285, 850, 0
	Click, 285, 850, Left
	MouseMove, %oldX%, %oldY%, 0
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
	MouseMove, 1585, 715, 0
	MouseClickDrag, Left, 1585, 715, 1585, 0, 3
	MouseMove, 1585, 715, 0
	MouseClickDrag, Left, 1585, 715, 1585, 0, 3
	; Send {LButton up}
	; Sleep, 50
	; Send {LButton down}

	; MouseMove, 1130, 510, 0
	; Send {LButton down}
	; MouseMove, 1130, 0, 0
	; Send {LButton up}
}

DragTopDown() {
	MouseMove, 1585, 215, 0
	MouseClickDrag, Left, 1585, 215, 1585, 1050, 3
	MouseMove, 1585, 215, 0
	MouseClickDrag, Left, 1585, 215, 1585, 1050, 3
}

; Wizard down 1625, 410
#IfWinActive Bloons Monkey City
w::
	SelectTower("down", 1625, 410)
return

; Engineer up 1150, 460
#IfWinActive Bloons Monkey City
e::
	SelectTower("up", 1150, 430)
return

; Spactory down 1550, 590
#IfWinActive Bloons Monkey City
s::
	SelectTower("up", 1550, 590)
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

; Farm down 1550, 525
#IfWinActive Bloons Monkey City
f::
	; In reality 525, but 440 is one up, and dragging has that offset
	SelectTower("down", 1550, 490)
return

#IfWinActive Save As
^SPACE::
	Send, {Right}
	Send, {Left}{Left}{Left}{Left}
	Send, {BS}{BS}{BS}{BS}
	Send, {Enter}
	Send, {Left}
	Send, {Enter}
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

; Mappings for tab iteration in Brave, shit browser as far as keyboard shortcuts go

; Disable ctrl+shift+left and right for now
; #IfWinActive - Opera
; ^+Right::
; 	Send, {Ctrl down}{Tab}{Ctrl up}
; return

; #IfWinActive - Opera
; ^+Left::
; 	Send, {Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}
; return

#IfWinActive - Opera
^+Up::
	Send, {Ctrl down}{Tab}{Ctrl up}
return

#IfWinActive - Opera
^+Down::
	Send, {Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}
return

#IfWinActive - Opera
!Right::
	Send, {Ctrl down}{Tab}{Ctrl up}
return

#IfWinActive - Opera
!Left::
	Send, {Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}
return

#IfWinActive The Sims
Numpad3::
	Send, q
return

DragBottomUpBTD5() {
	MouseMove, 1590, 735, 0
	Click, 1590, 735
	Click, 1590, 735
	Click, 1590, 735
}

DragTopDownBTD5() {
	MouseMove, 1590, 160, 0
	Click, 1590, 160
	Click, 1590, 160
	Click, 1590, 160
}

SelectTowerBTD5(dir, x, y) {
	MouseGetPos, oldX, oldY

	if (dir == "down") {
		; MsgBox, down %dir%
		DragBottomUpBTD5()
	} else if (dir == "up") {
		; MsgBox, up %dir%
		DragTopDownBTD5()
	}

	MouseMove, %x%, %y%, 0
	Send {LButton down}
	MouseMove, %oldX%, %oldY%, 0
}

#IfWinActive Bloons TD5
+h::
	MouseGetPos, oldX, oldY
	MsgBox, Pos(%oldX%, %oldY%)
return

#IfWinActive Bloons TD5
z::
	Send, {,}
return

#IfWinActive Bloons TD5
x::
	Send, {.}
return

X_1 = 1545
X_2 = 1635
Y_1 = 225
Y_2 = 325
Y_3 = 415
Y_4 = 490
Y_5 = 590
Y_6 = 665

; Dart monkey up 1545, 665
#IfWinActive Bloons TD5
q::
	SelectTowerBTD5("up", 1545, 225)
return

; Tack shooter up 1545, 225
#IfWinActive Bloons TD5
w::
	SelectTowerBTD5("up", 1635, 225)
return

; Sniper monkey up 1545, 325
#IfWinActive Bloons TD5
e::
	SelectTowerBTD5("up", 1545, 325)
return

; Super monkey up 1545, 665
#IfWinActive Bloons TD5
a::
	SelectTowerBTD5("up", 1545, 665)
return

; Wizard up 1545, 665
#IfWinActive Bloons TD5
s::
	SelectTowerBTD5("up", 1635, 665)
return

; Village down 1545, 315
#IfWinActive Bloons TD5
d::
	SelectTowerBTD5("down", 1545, 315)
return

; Banana farm down 1635, 315
#IfWinActive Bloons TD5
f::
	SelectTowerBTD5("down", 1635, 315)
return

; Mortar down 1635, 315
#IfWinActive Bloons TD5
g::
	SelectTowerBTD5("down", 1545, 415)
return

; Dartling gunner down 1635, 315
#IfWinActive Bloons TD5
h::
	SelectTowerBTD5("down", 1635, 415)
return

; Engineer down 1545, 585
#IfWinActive Bloons TD5
c::
	SelectTowerBTD5("down", 1545, 585)
return

; Bloonchipper down 1635, 585
#IfWinActive Bloons TD5
v::
	SelectTowerBTD5("down", 1635, 585)
return

; Sub down 1545, 675
#IfWinActive Bloons TD5
b::
	SelectTowerBTD5("down", 1545, 675)
return

; Road spikes fixed 1545, 835
#IfWinActive Bloons TD5
n::
	SelectTowerBTD5("none", 1545, 835)
return

; Pineapple fixed 1635, 835
#IfWinActive Bloons TD5
m::
	SelectTowerBTD5("none", 1635, 835)
return

#IfWinActive StudioNEOV2
!WheelUp::
	Send, {+ down}
	Sleep, 155
	Send, {+ up}
return

#IfWinActive StudioNEOV2
!WheelDown::
	Send, {¿ down}
	Sleep, 155
	Send, {¿ up}
return

DropFiles(window, files)
{
  for k,v in files
    memRequired+=StrLen(v)+1
  hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired+21)
  dropfiles := DllCall("GlobalLock", "ptr", hGlobal)
  NumPut(offset := 20, dropfiles+0, 0, "uint")
  for k,v in files
    StrPut(v, dropfiles+offset, "utf-8"), offset+=StrLen(v)+1
  DllCall("GlobalUnlock", "ptr", hGlobal)
  PostMessage, 0x233, hGlobal, 0,, %window%

  ; MsgBox, %ErrorLevel%
  if ErrorLevel
    DllCall("GlobalFree", "ptr", hGlobal)
}

#IfWinActive KK Manager
space::
	list_files := {}

	WinGetPos, X, Y, W, H, KK Manager
	WinGetTitle, managerTitle

	; MsgBox, at %X%x%Y%, size %W%x%H%

	whereX := X + W - 60
	whereY := Y + H - 200

	MouseMove, %whereX%, %whereY%, 0
	Click, %whereX%, %whereY%

	; Set tab focus on a text field
	Send, {Tab}{Enter}{Tab}{Enter}{Tab}{Enter}
	; Set tab focus on topmost text field
	Send, {Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}
	; Set tab focus on 3rd text field with filename
	; 2nd if KKS
	If InStr(managerTitle, "[KoikatsuSunshine]")
		Send, {Down}
	Else
		Send, {Down}{Down}
	; Set tab focus on text field content
	Send, {Tab}
	Send, {Ctrl down}C{Ctrl up}

	If InStr(managerTitle, "[KoikatsuSunshine]")
		list_files.Insert(0, "C:\\Users\\Doru\\Downloads\\Pirated\\ISL\\KKS\\UserData\\chara\\reflection\\" + clipboard)
	Else
		list_files.Insert(0, "C:\\Users\\Doru\\Downloads\\Pirated\\ISL\\HS2\\UserData\\chara\\reflection\\" + clipboard)

	; MsgBox % list_files[0]

	DropFiles("ahk_class UnityWndClass", list_files)
return

#IfWinActive KK Manager
LButton::
	Send, {LButton}
return

#IfWinActive Don't Starve Together
CapsLock::
	Send, 1
return

#IfWinActive ahk_exe explorer.exe
~LButton::
	MouseGetPos, x, y

	if (y < 4) {
		MouseMove, %x%, 4, 0
		Click, %x%, 4
		; MouseMove, %x%, %y%, 0

		; MsgBox, bruh
	}
return

#IFWinActive Skyrim
MButton::
	Send, {W down}
return

#IFWinActive Skyrim
MButton up::
	Send, {W up}
return