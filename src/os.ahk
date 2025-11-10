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
    exec := shell.Run("powershell -Command `"" StrReplace(command, '"', '\"') "`" | clip", 0, True)

    return Trim(A_Clipboard, ' `t`n`r')
}

; Run a command in a hidden PowerShell window, and returns its output (but better)
; It still writes to the clipboard
ExecPS2(command) {
    tempFile := A_Temp "\ahk_temp_ps_script.ps1"
    try {
        FileDelete(tempFile)
    }

    FileAppend(command, tempFile)

    A_Clipboard := ""

    shell := ComObject("WScript.Shell")
    shell.Run("powershell -Command `"powershell -ExecutionPolicy Bypass -File \`"$env:TMP/ahk_temp_ps_script.ps1\`" | Set-Clipboard`"", false, true)

    return Trim(A_Clipboard, ' `t`n`r')
}

ExecPS3(command) {
    tempFile := A_Temp "\ahk_temp_ps_script.ps1"
    try {
        FileDelete(tempFile)
    }

    FileAppend(command, tempFile, 'UTF-8') ; with BOM

    A_Clipboard := ""

    shell := ComObject("WScript.Shell")
    shell.Run("powershell -Command `"[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; powershell -ExecutionPolicy Bypass -File \`"$env:TMP/ahk_temp_ps_script.ps1\`" | Out-File -FilePath \`"$env:TMP/ahk_temp_ps_output.txt\`"", false, true)

    output := FileRead(A_Temp "\ahk_temp_ps_output.txt")
    FileDelete(A_Temp "\ahk_temp_ps_output.txt")

    return output
}
