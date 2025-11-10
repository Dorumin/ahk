#Requires AutoHotkey v2.0

#HotIf WinActive('ahk_exe HD-Player.exe')

Escape:: {
    MouseMove(50, 50, 0)
    Send('{LButton down}')
    Sleep(10)
    Send('{LButton up}')
}

Left::
Space:: {
    Send('{LButton down}')
    Sleep(10)
    Send('{LButton up}')
}

Up:: {
    MouseMove(1915, 500, 0)
    ; Sleep(50)
    Send('{LButton down}')
    ; Sleep(10)
    MouseMove(0, -150, 1, 'R')
    ; Sleep(10)
    Send('{LButton up}')
    Sleep(150)
    if GetKeyState('up', 'P') {
        Send('{LButton down}')
        MouseMove(0, -150, 1, 'R')
        Send('{LButton up}')
    }
}

Down:: {
    MouseMove(1915, 500, 0)
    ; Sleep(50)
    Send('{LButton down}')
    ; Sleep(10)
    MouseMove(0, 150, 1, 'R')
    ; Sleep(10)
    Send('{LButton up}')
    Sleep(150)
    if GetKeyState('down', 'P') {
        Send('{LButton down}')
        MouseMove(0, 150, 1, 'R')
        Send('{LButton up}')
    }
}

Right:: {
    MouseMove(1500, 500, 0)
    Send('{LButton down}')
    ; Sleep(10)
    MouseMove(-100, 0, 2, 'R')
    ; Sleep(10)
    Send('{LButton up}')
}

#HotIf
