; Hide any active notifications
HideTrayTip() {
    TrayTip
    if SubStr(A_OSVersion, 1, 3) = "10." {
        A_IconHidden := true
        Sleep(200)
        A_IconHidden := false
    }
}

; Show a notification for a short while
TrayTipTimeout(ms, message, title := "") {
    TrayTip(message, title)
    SetTimer(HideTrayTip, -ms)
}

; Run a command in a hidden PowerShell window, and return its output
ExecPS3(command, show_window := false, redirect_stderr := false) {
    tempFile := A_Temp "\ahk_temp_ps_script.ps1"
    try {
        FileDelete(tempFile)
    }

    FileAppend(command, tempFile, 'UTF-8') ; with BOM

    ; A_Clipboard := ""

    shell := ComObject("WScript.Shell")
    command :=
        "powershell -Command `"[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; powershell -ExecutionPolicy Bypass -File \`"$env:TMP/ahk_temp_ps_script.ps1\`""
    if redirect_stderr {
        command .= " 2>&1"
    }

    command .= " | Tee-Object -FilePath \`"$env:TMP/ahk_temp_ps_output.txt\`""
    wait_for_exit := true

    shell.Run(command, show_window, wait_for_exit)

    output := FileRead(A_Temp "\ahk_temp_ps_output.txt")
    ; FileDelete(A_Temp "\ahk_temp_ps_output.txt")

    return output
}

SetCursorSize(sz) {
    DllCall("SystemParametersInfo", "Int", 0x2029, "Int", 0, "Ptr", sz, "Int", 0x01)
}
