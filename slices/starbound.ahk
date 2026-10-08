#Include ../src/all.ahk

#HotIf WinActive('ahk_exe starbound.exe')

MButton:: {
    ; RestoreMousePosition(true, Restored)
    ; Restored() {
    ;     found := ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, '*1 ./assets/takeall.png')

    ;     if found {
    ;         Click(x + 50, y + 10)
    ;         Sleep(1000)
    ;     }
    ; }
    RestoreMousePosition(true, () => (
        Click(1530, 655)
        Click(1440, 680)
        ; Sleep(200)
    ))
}

#HotIf
