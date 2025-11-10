#Include ../src/all.ahk

global HotCaneSwitching := false
global HadCaneEquipped := false
global SHOW_HEX := false

global EQUIPPED_CANE_DEFAULT := "0xC2CA5C"
global EQUIPPED_CANE_ANCIENT := "0xC38A2B"
global EQUIPPED_CANE_CORRUPTED := "0x2F2A3F"
global UNEQUIPPED_CANE_DEFAULT := "0xCBCD5E"
global UNEQUIPPED_CANE_ANCIENT := "0xCD922E"
global UNEQUIPPED_CANE_CORRUPTED := "0x272336"

global EQUIPPEDS := [
    EQUIPPED_CANE_DEFAULT,
    EQUIPPED_CANE_ANCIENT,
    EQUIPPED_CANE_CORRUPTED,
]
global UNEQUIPPEDS := [
    UNEQUIPPED_CANE_DEFAULT,
    UNEQUIPPED_CANE_ANCIENT,
    UNEQUIPPED_CANE_CORRUPTED,
]

#HotIf WinActive("ahk_exe dontstarve_steam_x64.exe")

; Quick sell
F22:: RestoreMousePosition(true, () => (
    Click()
    Sleep(100)
    MouseMove(1180, 985, 0)
    Sleep(100)
    Click(1180, 985)
    Sleep(100)
    MouseMove(960, 820, 0)
    Sleep(100)
    Click(960, 820)
    Sleep(100)
    MouseMove(790, 615, 2)
    Sleep(100)
    Click(790, 615)
    Sleep(100)
))

#HotIf
