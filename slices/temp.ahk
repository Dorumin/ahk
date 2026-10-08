#Include ../src/all.ahk

#HotIf WinActive("ahk_exe SumatraPDF.exe")

Left:: Click(1150, 200)
Right:: Click(1300, 200)
Up:: Click(1200, 135)
Down:: Click(1200, 275)

#HotIf

#HotIf WinActive("ahk_exe VampireSurvivors.exe") or WinActive("ahk_exe flashplayer_32_sa.exe")

F24:: Click()

#HotIf

#HotIf WinActive('Results - Google Sheets - Opera')

; c::Send('c{Tab}')
; u::Send('u{Tab}')
; r::Send('r{Tab}')
; l::Send('l{Tab}')
; q::Send('{Down}{Ctrl down}{Left}{Ctrl up}')

#HotIf

#HotIf WinActive("ahk_exe Undertale Yellow.exe") or WinActive("ahk_exe DELTARUNE.exe")

a::z
s::x
d::c
q:: {
    while GetKeyState('q', 'P') {
        LongPress('z', 30, 30)
    }
}

f1::f1

F2:: {
    loop {
        LongPress('Left', 100)
        Sleep(1000)
        LongPress('Right', 100)
        Sleep(15000)
    }
}

#HotIf

; ListenInterceptionDevices(
;     (device) => device.IsMouse,
;     (device) => (
;         ; AHI.SubscribeMouseMove(device.id, false, MouseEvent)
;     )
; )

curx := 0
cury := 0
MouseGetPos(&curx, &cury)

MouseEvent(x, y) {
    global curx, cury

    curx += x
    cury += y

    if true {
        return
    }

    LogMessage("x: {} y: {}", curx, cury)
}

F24:: {
    hWnd := WinActive("A") ; Get active window
    Sleep(2000)
    DllCall("FlashWindow", "UInt", hWnd, "Int", True)
}

; F23:: LongPress('LButton', 10, 10)
