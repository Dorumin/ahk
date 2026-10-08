#Include ../src/all.ahk

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

F16:: {
	Send('{LButton down}')
	Sleep(1010)
	Send('{LButton up}')
	Sleep(200)

	last_pixel := ""

	start := A_TickCount

	Loop {
		if A_PriorKey != "F16" {
			return
		}

		if (A_TickCount - start) > 25000 {
			break
		}

		; color := PixelGetColor(967, 409, 'Alt')
		; color := PixelGetColor(966, 425, 'Alt')
		color := PixelGetColor(966, 420, 'Alt')
		color_rgb := color + 0

		if color != last_pixel {
			last_pixel := color

			matches := (
				ColorNear(color_rgb, 0xD7CE09, 6)
				or ColorNear(color_rgb, 0xEBD80C, 6)
				or ColorNear(color_rgb, 0xE8E40B, 6)
				or ColorNear(color_rgb, 0xF3B504, 6)
				or ColorNear(color_rgb, 0xF2EF05, 6)
				or ColorNear(color_rgb, 0xCFC50A, 6)
				or ColorNear(color_rgb, 0xC08B03, 6)
				or ColorNear(color_rgb, 0xC99104, 6)
				or ColorNear(color_rgb, 0xB6A810, 6)
				or ColorNear(color_rgb, 0xB27F04, 6)
				or ColorNear(color_rgb, 0xF8F804, 6)
			)

			LogMessage("pixel: {} ({})", ColorToHex(color_rgb), matches)

			if matches {
				break
			}
		}
	}

	Send('{LButton down}')
	Sleep(50)
	Send('{LButton up}')
}

F18:: {
	loop {
		if GetKeyState('F18', 'P') != '1' {
			break
		}

		SendQueue(
			'{LButton down}',
			30,
			'{LButton up}',
			150, ; 100 when not going down
			'{RShift down}',
			5,
			'{Delete down}',
			5,
			'{R down}',
			30,
			'{R up}',
			5,
			'{Delete up}',
			5,
			'{RShift up}'
		)
	}
}

F24:: {
	Loop {
		if A_PriorKey != "F24" {
			return
		}

		Send('{w down}')

		Loop 35 {
			LongPress('LButton', 30)
			Sleep(100)
		}

		Send('{w up}')

		Send('{s down}')

		Loop 35 {
			LongPress('LButton', 30)
			Sleep(100)
		}

		Send('{s up}')
	}
}

#HotIf
