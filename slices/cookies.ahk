#Include ../src/all.ahk


#HotIf WinActive('ahk_exe Cookie Clicker.exe')

clicker_should_stop := true
clicker_mode := 2
clicker_index := 0

LogBase2(nom) {
    return Log(nom) / Log(2)
}

Clicker() {
    global clicker_mode, clicker_index, clicker_should_stop

    if clicker_should_stop {
        SetTimer(Clicker, 0)
        SetTimer(WindowChecker, 0)

        return
    }

    if clicker_mode == 1 {
        Click()
    } else {
        cindex := Floor(clicker_index / 5)
        distance := Floor(LogBase2(cindex)) * 30
        around := 2 ** (distance + 1) - cindex

        ; around := LogBase2(clicker_index)

        ; around := Mod(clicker_index, 10)
        ; distance := Floor(clicker_index / 10) * 15

        x := distance * Cos(around * 360 / 0.01745329252)
        y := distance * Sin(around * 360 / 0.01745329252)

        Click(287 + x, 430 + y)

        clicker_index := Mod(clicker_index + 1, 80 * 5)
    }
}

WindowChecker() {
    global clicker_should_stop

    if !WinActive('ahk_exe Cookie Clicker.exe') {
        clicker_should_stop := true
    }
}

^+g:: {
    global clicker_mode, clicker_index, clicker_should_stop

    static running := false
    clicker_index := 0
    clicker_should_stop := false

    if running {
        SetTimer(Clicker, 0)
        SetTimer(WindowChecker, 0)
    } else {
        if clicker_mode == 1 {
            clicker_mode := 2
        } else {
            clicker_mode := 1
        }

        SetTimer(Clicker, 10)
        SetTimer(WindowChecker, 10)
    }

    running := !running
}

^+h:: {
    Serj(img, xf, yf) {
        found := ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, img)

        if found {
            ; MsgBox(Format("{} {}", x, y))
            Click(x + xf, y + yf)
        }
    }

    Loop {
        ; 4 is reliable, not fast

        if WinActive('ahk_exe Cookie Clicker.exe') {
            Serj('*35 ./assets/WrathContract.png', 50, 50)
            Serj('*35 ./assets/Contract.png', 50, 50)
            Serj('*35 ./assets/Golden.png', 50, 50)
            Serj('*8 ./assets/Pledge.png', 50, 50)
            Serj('*1 ./assets/1dolir.png', 110, 50)
            Serj('*1 ./assets/2dolir.png', 110, 50)
        }

        Sleep(100)
    }
}

^+j:: {
    Loop {
        Click(1450, 120)
        Sleep(100)
        Click(960, 610)
        Sleep(6000)
        Click(960, 160)
        Sleep(100)
        Click(935, 555)
        Sleep(3000)

        Loop 2 {
            Loop 5 {
                Click(1720, 211)
                Sleep(200)
            }

            MouseMove(1300, 500)
            Sleep(250)

            MouseMove(1725, 900)
            Sleep(250)

            Loop 10 {
                Send('{Shift down}')
                Sleep(50)
                Click()
                Send('{Shift up}')
                LongPress('WheelDown', 50)
                Sleep(50)
            }

            Loop 10 {
                Send('{Shift down}')
                Sleep(50)
                Click()
                Send('{Shift up}')
                Send('{WheelUp}')
                Sleep(50)
            }

            Sleep(100)

        }

        Loop 5 {
            Click(1720, 211)
            Sleep(200)
        }

    }
}

^+k:: {
    if true {
        return
    }

    Loop {
        Click(1450, 120)
        Sleep(100)
        Click(960, 610)
        Sleep(6000)
        Click(960, 160)
        Sleep(100)
        Click(935, 555)
        Sleep(2000)

        Loop 3 {
            Click(1720, 211)
            Sleep(200)
        }

        MouseMove(1300, 500)
        Sleep(250)

        Click(1725, 950)
        Sleep(250)

        Click(1300, 390)
        Sleep(250)

        Loop 30 {
            Click(1200, 300)
            Sleep(100)
        }

        Sleep(1500)
    }
}

^b:: {
    Send('^o')
    Send('^v')
    Send('{Enter}')
    Sleep(1000)
    ; Click()
}

#HotIf
