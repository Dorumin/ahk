#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe blender.exe")

ReleaseLoop() {
    if GetKeyState('F16', 'P') {
        return
    }

    SendQueue('{MButton up}')

    SetTimer(ReleaseLoop, 0)
}

*F16:: {
    Send('{Shift down}{MButton down}{Shift up}')

    SetTimer(ReleaseLoop, 50)
}

#HotIf
