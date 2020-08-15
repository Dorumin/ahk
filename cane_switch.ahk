; These are built-in, not touching that shit

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Holding down fight
#MaxHotkeysPerInterval 10000

; This file is for automatically switching between weapon and walking cane during fights

; This flag just tells whether the switching mechanism is enabled
CaneSwitchEnabled := 0

; This one says if you're currently holding a cane
; On enabled (middle mouse button), it's assumed you're holding it
HoldingCane := 1

; Whether the loop is looping
LoopingColor := 0

; SEX := 250
; SEY := 735
; These coordinates are for checking the tool in fact switched
; I hope this doesn't bring issues if the tool breaks
SLOT_1_X := 237
SLOT_1_Y := 742

; BGR color for empty slot
; CANE_COLOR := "0xD1E8F4"

SwapIfSwitched(to) {
	global CaneSwitchEnabled, HoldingCane, SLOT_1_X, SLOT_1_Y

	PixelGetColor, LastColor, %SLOT_1_X%, %SLOT_1_Y%

	if (CaneSwitchEnabled == 1 and HoldingCane != to) {
        HoldingCane := to

		Send, 1

		if (LoopingColor == 0) {
			LoopigColor := 1

			Loop {
				PixelGetColor, CurrentColor, %SLOT_1_X%, %SLOT_1_Y%

				if (LastColor != CurrentColor) break

				Sleep, 200
				Send, 1
			}

			LoopingColor := 0
		}
	}
}

#IfWinActive Don't Starve Together
~w::SwapIfSwitched(1)
#IfWinActive Don't Starve Together
~a::SwapIfSwitched(1)
#IfWinActive Don't Starve Together
~s::SwapIfSwitched(1)
#IfWinActive Don't Starve Together
~d::SwapIfSwitched(1)
#IfWinActive Don't Starve Together
~f::SwapIfSwitched(0)
#IfWinActive Don't Starve Together
~^f::SwapIfSwitched(0)

; #IfWinActive Don't Starve Together
; ~1::SetCaneSlot(1)
; #IfWinActive Don't Starve Together
; ~2::SetCaneSlot(2)
; #IfWinActive Don't Starve Together
; ~3::SetCaneSlot(3)
; #IfWinActive Don't Starve Together
; ~4::SetCaneSlot(4)
; #IfWinActive Don't Starve Together
; ~5::SetCaneSlot(5)
; #IfWinActive Don't Starve Together
; ~6::SetCaneSlot(6)
; #IfWinActive Don't Starve Together
; ~7::SetCaneSlot(7)
; #IfWinActive Don't Starve Together
; ~8::SetCaneSlot(8)
; #IfWinActive Don't Starve Together
; ~9::SetCaneSlot(9)

#IfWinActive Don't Starve Together
~LButton::SwapIfSwitched(1)

#IfWinActive Don't Starve Together
~MButton::
	HoldingCane := 1

	if (CaneSwitchEnabled == 0) {
		CaneSwitchEnabled := 1
	} else {
		CaneSwitchEnabled := 0
	}
return
