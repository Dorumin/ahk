#Include ..\lib\jsongo.v2.ahk

#HotIf WinActive("ahk_exe SumatraPDF.exe")

Left:: Click(1150, 200)
Right:: Click(1300, 200)
Up:: Click(1200, 135)
Down:: Click(1200, 275)

#HotIf

#HotIf WinActive("ahk_exe VampireSurvivors.exe") or WinActive("ahk_exe flashplayer_32_sa.exe")

F24:: Click()

#HotIf

#HotIf WinActive('ahk_exe Palworld-Win64-Shipping.exe')

*WheelLeft::SendQueue('{WheelUp}', 30, '{WheelDown}', 100)
*F16::SendQueue('{WheelDown}', 100)
*F17::SendQueue('{WheelUp}', 100)

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

#HotIf

tick_test_count := 0
TickTest() {
    global tick_test_count

    LogMessage(WinGetClass(WinActive('A')))

    tick_test_count += 1

    if Mod(tick_test_count, 50) == 0 {
        SetTimer(TickTest, 0)
    }
}

F24::SetTimer(TickTest, 100)
