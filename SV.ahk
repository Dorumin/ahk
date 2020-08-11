#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

WaterRight() {
	Send, {d down}
	Sleep, 50
	Send, {d up}
	Send, {c down}
	Sleep, 2750
	Send, {c up}
	Sleep, 800
	Send, {a down}
	Sleep, 50
	Send, {a up}
	Send, {s down}
	Sleep, 600
	Send, {s up}
}

WalkRight() {
	Send, {d down}
	Sleep, 2800
	Send, {d up}
	Send, {a down}
	Sleep, 50
	Send, {a up}
	Send, {w down}
	Sleep, 600
	Send, {w up}
}

WaterLeft() {
	Send, {a down}
	Sleep, 50
	Send, {a up}
	Send, {c down}
	Sleep, 2750
	Send, {c up}
	Sleep, 800
	Send, {d down}
	Sleep, 50
	Send, {d up}
	Send, {w down}
	Sleep, 600
	Send, {w up}
}

PlayingStardewValley() {
	pid := WinActive("Stardew Valley")
	active := pid != 0
	return active
}

AlignTopLeft() {
	Send, {w down}
	Send, {a down}
	Sleep, 100
	Send, {w up}
	Send, {a up}
	Send, {s down}
	Sleep, 60
	Send, {s up}
	Send, {d down}
	Sleep, 160
	Send, {d up}
}

^q::
	If PlayingStardewValley() {
		Send, {c down}
		Sleep, 1035
		Send, {c up}
	} else {
		Send, ^q
	}
return

^e::
	If PlayingStardewValley() {
		MouseMove, 0, 0, 0
		AlignTopLeft()
		Loop, 5 {
			WaterRight()
		}
		WalkRight()
		Loop, 5 {
			WaterLeft()
		}
	} else {
		Send, ^e
	}
return
