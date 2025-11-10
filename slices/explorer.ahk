#Include ../src/all.ahk

GroupAddTree({
    ExplorerWindow: {
        Explorer: 'ahk_exe explorer.exe ahk_class CabinetWClass',
        PickerDialog: 'ahk_class #32770',
        Picker: 'ahk_exe PickerHost.exe'
    }
})

; Iterate over elements in folder with scroll wheel
#HotIf WinActive("ahk_group ExplorerWindow") and MouseShiftHeld()

WheelUp::Left
WheelDown::Right

WheelLeft:: {
    Send('{ScrollLock up}{XButton1}')
    Sleep(150)
}
WheelRight:: {
    Send('{ScrollLock up}{XButton2}')
    Sleep(150)
}

#HotIf

#HotIf WinActive("ahk_group ExplorerWindow") or WinActive("ahk_group PickerDialog")

Pause:: {
    if MouseShiftHeld() {
        Send('{Up}')
    } else {
        Send('{Pause up}')
        Sleep(15)
        Send('{Alt down}{Up down}')
        Sleep(15)
        Send('{Up up}{Alt up}')
    }
}

Insert:: {
    if MouseShiftHeld() {
        Send('{Down}')
    } else {
        Send('{Pause up}')
        Sleep(15)
        Send('{Alt down}{Left down}')
        Sleep(15)
        Send('{Left up}{Alt up}')
    }
}


; I really don't use the search bar that much
F3::return

; Overwrite Ctrl+L so it also clears the previous executable
; so instead it's always the current folder
; $^l:: {
;     Send("^l")
;     Sleep(50)
;     Send("{BS}")
;     Sleep(50)
;     Send("{Esc}")
; }

; Tab switching with side buttons
; Explorer is still bad at picking up key combinations
F17:: {
    Send('{Ctrl down}')
    Sleep(10)
    Send('{Tab}')
    Sleep(10)
    Send('{Ctrl up}')
}

F16:: {
    Send('{Ctrl down}{Shift down}')
    Sleep(10)
    Send('{Tab}')
    Sleep(10)
    Send('{Shift up}{Ctrl up}')
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
        ; Send("{F5}")
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
        ; Send("{F5}")
	}
}

UnselectFilesExplorer() {
    ; This long-winded charade is a way to unselect any and all files in explorer
    ; In Windows 10, you could do it with alt -> h -> s -> n
    ; Windows 11 removed the ribbon, so now this hack will have to do
    ; Weird input handling demands sleeps between each keystroke, eugh. I don't recall
    ; this being a problem before, but maybe modifier keys are weird
    Send('{Ctrl down}')
    Sleep(10)
    Send('{Space}')
    Sleep(10)
    Send('{Ctrl up}')
    Sleep(10)
    Send('{Shift down}')
    Sleep(10)
    Send('{Space}')
    Sleep(10)
    Send('{Shift up}')
    Sleep(10)
    Send('{Ctrl down}')
    Sleep(10)
    Send('{Space}')
    Sleep(10)
    Send('{Ctrl up}')
    Sleep(10)
}

; Set large previews
F19:: {
    static LoopyBanoopy := 1

    if A_PriorKey == 'F19' and LoopyBanoopy < 6 {
        LoopyBanoopy += 1
    } else {
        LoopyBanoopy := 1
    }

    Send('^+' LoopyBanoopy)

    ; UnselectFilesExplorer()
    ; Send('{AppsKey}')
    ; Sleep(10)
    ; Send('{Down}{Enter}{Enter}')
}

; Set sort order name, reverse if current
F20:: {
    UnselectFilesExplorer()
    Send('{AppsKey}')
    Sleep(10)
    Send("{Down}{Down}{Right}{Enter}")
}

F24:: {
    Click('Right')
    Sleep(100)
    Send('m')
    Sleep(200)
    Send('len')
    Sleep(200)
    Send('{Space}')
    Sleep(200)
    Send('{Enter}')
}

#HotIf

; Make taskbar scrolling actually mute and unmute sound
; #HotIf MouseIsOver("ahk_class Shell_TrayWnd")
; ~WheelUp::
; ~WheelDown:: {
;     Loop 2 {
;         volume := SoundGetVolume()

;         if volume == 0 {
;             SoundSetMute(true)
;         } else {
;             SoundSetMute(false)
;         }

;         Sleep(30)
;     }
; }
; #HotIf

#HotIf WinActive('ahk_exe OneCommander.exe')

F16::^+Tab
F17::^Tab

Pause::!Up
Insert::!Left

#HotIf
