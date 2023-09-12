#HotIf WinActive("ahk_exe explorer.exe ahk_class CabinetWClass")

; I really don't use the search bar that much
F3::return

; Overwrite Ctrl+L so it also clears the previous executable
; so instead it's always the current folder
$^l:: {
    Send("^l")
    Sleep(50)
    Send("{BS}")
    Sleep(50)
    Send("{Esc}")
}

; Tab switching with side buttons
F17::
ScrollLock & WheelDown:: {
    Send("^{Tab}")
}

F16::
ScrollLock & WheelUp:: {
    Send("^+{Tab}")
}

ScrollLock & WheelLeft::Send('{ScrollLock up}{XButton1}')
ScrollLock & WheelRight::Send('{ScrollLock up}{XButton2}')

; The top of the tabs is not glued to the top of the screen, which is LITERALLY THE WORST
; So if a click is done very close to the top of the screen, redirect it to be not so close
~LButton:: {
    x := 0
    y := 0
	MouseGetPos(&x, &y)

	if (y < 7) {
		MouseMove(x, 7, 0)
		Click(x, 7)
		MouseMove(x, y, 0)

        ; Experiment with reloads on tab switch
        Send("{F5}")
	}
}

; Ditto
~MButton:: {
    x := 0
    y := 0
	MouseGetPos(&x, &y)

	if (y < 4) {
		MouseMove(x, 4, 0)
		Click(x, 4, "M")
		MouseMove(x, y, 0)

        ; Experiment with reloads on tab switch
        Send("{F5}")
	}
}

; Quick setup for folder viewing (autodetect doesn't work well; sort reverse name & big preview)
F19:: {
    Send("{AppsKey}{Down}{Enter}{Enter}")
}

; Reverse name
F20:: {
    Send("{AppsKey}{Down}{Down}{Right}{Enter}")
}
#HotIf

; Make taskbar scrolling actually mute and unmute sound
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
~WheelUp::
~WheelDown:: {
    Loop 2 {
        volume := SoundGetVolume()

        if volume == 0 {
            SoundSetMute(true)
        } else {
            SoundSetMute(false)
        }

        Sleep(30)
    }
}
#HotIf