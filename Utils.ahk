global LogsEnabled := true

; Send a message to log.txt for debugging
LogMessage(text) {
    if not LogsEnabled {
        return
    }

    DateString := Format("{}-{}-{} {}:{}:{}.{}", A_Year, A_Mon, A_MDay, A_Hour, A_Min, A_Sec, A_MSec)

    FileAppend(DateString " " text "`n", A_ScriptDir "\log.txt")
}

; Self explanatory
ArrayIncludes(array, needle) {
    for v in array {
        if v == needle {
            return true
        }
    }

    return false
}

; Matcher like WinActive, useful in #HotIf condition
MouseIsOver(WinTitle) {
    MouseGetPos( , , &WindowID)

    return WinExist(WinTitle " ahk_id " WindowID)
}

; Hide any active notifications
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}

; Store the mouse position, run a function and bring the mouse back
RestoreMousePosition(callback) {
    x := 0
    y := 0
	MouseGetPos(&x, &y)

    callback()
    MouseMove(x, y, 0)
}

; Show a notification for a short while
TrayTipTimeout(ms, message, title := "") {
    TrayTip(message, title)
    SetTimer(HideTrayTip, -ms)
}

; Function for dropping a list of file paths into application matched by WindowTitle
DropFiles(window, files) {
    memRequired := 0

    for k, v in files {
        memRequired += StrLen(v) + 1
    }

    hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired + 21)
    dropfiles := DllCall("GlobalLock", "ptr", hGlobal)

    offset := 20
    NumPut("uint", 20, dropfiles, 0)

    for k, v in files {
        StrPut(v, dropfiles + offset, StrLen(v), "utf-8")
        offset += StrLen(v) + 1
    }

    DllCall("GlobalUnlock", "ptr", hGlobal)

    PostMessage(0x233, hGlobal, 0,, window)
    DllCall("GlobalFree", "ptr", hGlobal)
}

; Run a command in a hidden PowerShell window, and return its output
; It does a hacky pipe-into-clip to extract output, the alternative is save to a file
; I should eventually do the file thing. At the moment it drops old clipboard contents
; Fine by me, for now
ExecPS(command) {
    shell := ComObject("WScript.Shell")
    ; exec := shell.Exec("powershell -Command `"" command "`"")
    ; return exec.StdOut.ReadAll()
    exec := shell.Run("powershell -Command `"" command "`" | clip", 0, True)

    return Trim(A_Clipboard, ' `t`n`r')
}