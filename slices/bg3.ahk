#Include ../src/all.ahk

Y_COORD_TIER_1 := 1005
Y_COORD_TIER_2 := 960
Y_COORD_TIER_3 := 915

#HotIf WinActive("ahk_exe bg3_dx11.exe")

F1:: Send('{F1}')
F16::Home
F18::F5

SelectOption(key, y_coord, x_index) {
    x_start := 0

    if PixelGetColor(629, 1030, 'RGB') == "0x633C24" {
        x_start := 665
    } else if PixelGetColor(575, 1030, 'RGB') == "0x7B492D" {
        x_start := 610
    } else if PixelGetColor(553, 1030, 'RGB') == '0x7B492D' {
        x_start := 590
    }

    if x_start == 0 {
        Send(key)
    } else {
        x := x_start + 45 * x_index

        RestoreMousePosition(true, () => (
            MouseMove(x, y_coord)
            LongPress('LButton', 5, 70)
        ))
    }
}

1:: SelectOption('1', Y_COORD_TIER_1, 0)
2:: SelectOption('2', Y_COORD_TIER_1, 1)
3:: SelectOption('3', Y_COORD_TIER_1, 2)
4:: SelectOption('4', Y_COORD_TIER_1, 3)
5:: SelectOption('5', Y_COORD_TIER_1, 4)
6:: SelectOption('6', Y_COORD_TIER_1, 5)
7:: SelectOption('7', Y_COORD_TIER_1, 6)

#HotIf WinActive("ahk_exe bg3_dx11.exe") and GetKeyState('Alt') == 0
; Tab::i

; z::SelectOption('z', Y_COORD_TIER_1, 12)

#HotIf
