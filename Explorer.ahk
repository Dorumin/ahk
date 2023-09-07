; Remap Win+E to open explorer.exe
; Why is this needed? Win+E already opens the Windows explorer!
; My install of Windows 11 doesn't let me set the Downloads folder as my landing page
; If I do, it crashes every time I try to open it. However, opening it from explorer.exe
; in the command line defaults to the Downloads folder, for some fucking reason
;
; Need to hide the System32 explorer.exe, not the Windows explorer.exe
; However, System32 explorer.exe opens up properly (in Downloads), so I use that
#e:: {
    if WinExist("ahk_exe explorer.exe ahk_class CabinetWClass") {
        WinActivate
        Send("{Tab}^t")
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
        Sleep(150)
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
    } else {
        Run("C:\Windows\System32\explorer.exe", , "Hide")
        WinWait("ahk_exe explorer.exe ahk_class CabinetWClass")
        WinActivate()
    }
}

; Bring back a bluetooth shortcut removed in Windows 11
; Win+K used to bring up a device list, now it brings up cast. Wtf
; Now, Win+B will toggle bluetooth connectivity and open the device list.
#b:: {
    Send("#a")
    Sleep(250)

    ; Can't pick it up...?
    ; exists := WinWait("ahk_class Windows.UI.Core.CoreWindow", , 2)

    ; Fuck it, hardcode coords
    RestoreMousePosition(true, () => (
        Click(1650, 565)
        Click(1710, 565)
    ))
}

; It's only funny a couple times
; Requires editing registry:
; HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisableLockWorkstation
; Ctrl+Alt+Delete still works to change user (win+L) or log out
#l::return

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
F24::
ScrollLock & WheelDown:: {
    Send("^{Tab}")
}

F21::
ScrollLock & WheelUp:: {
    Send("^+{Tab}")
}

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
F14 & LButton:: {
    Send("{AppsKey}{Down}{Enter}{Enter}{AppsKey}{Down}{Down}{Right}{Enter}")
}

F14 & RButton:: {
    Send("{AppsKey}{Down}{Enter}{Enter}")
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