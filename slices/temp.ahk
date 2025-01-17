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

WheelLeft:: {
    Send('{WheelUp}')
    Sleep(30)
    Send('{WheelDown}')
}

#HotIf
