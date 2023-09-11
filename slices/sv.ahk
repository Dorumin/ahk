#Requires AutoHotkey v2.0

WaterRight() {
	Send("{d down}")
	Sleep(50)
	Send("{d up}")
	Send("{c down}")
	Sleep(2750)
	Send("{c up}")
	Sleep(800)
	Send("{a down}")
	Sleep(50)
	Send("{a up}")
	Send("{s down}")
	Sleep(600)
	Send("{s up}")
}

WalkRight() {
	Send("{d down}")
	Sleep(2800)
	Send("{d up}")
	Send("{a down}")
	Sleep(50)
	Send("{a up}")
	Send("{w down}")
	Sleep(600)
	Send("{w up}")
}

WaterLeft() {
	Send("{a down}")
	Sleep(50)
	Send("{a up}")
	Send("{c down}")
	Sleep(2750)
	Send("{c up}")
	Sleep(800)
	Send("{d down}")
	Sleep(50)
	Send("{d up}")
	Send("{w down}")
	Sleep(600)
	Send("{w up}")
}

AlignTopLeft() {
	Send("{w down}")
	Send("{a down}")
	Sleep(100)
	Send("{w up}")
	Send("{a up}")
	Send("{s down}")
	Sleep(60)
	Send("{s up}")
	Send("{d down}")
	Sleep(160)
	Send("{d up}")
}

#HotIf WinActive("ahk_exe Stardew Valley.exe")
^q:: {
    Send("{c down}")
    Sleep(1035)
    Send("{c up}")
}

^e:: {
    MouseMove(0, 0, 0)
    AlignTopLeft()
    Loop 2 {
        WaterRight()
    }
    WalkRight()
    Loop 2 {
        WaterLeft()
    }
}
#HotIf
