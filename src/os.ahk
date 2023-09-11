; Hide any active notifications
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}

; Show a notification for a short while
TrayTipTimeout(ms, message, title := "") {
    TrayTip(message, title)
    SetTimer(HideTrayTip, -ms)
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