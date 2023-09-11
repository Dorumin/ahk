; Disable F1, almost always useless and pressed by accident
; Can be reactivated on a window-per-window basis
F1::return

; Reload the script when developing or it janks out
F14 & LButton::
!F5:: {
    ; Set slow title match mode for matching controls text. It's OK because we're gonna reload the script anyways
    SetTitleMatchMode('Slow')
    error_windows := WinGetList('ahk_exe AutoHotkey64.exe', 'The script was not reloaded; the old version will remain in effect.')

    for window_id in error_windows {
        WinClose(window_id)
    }

    Reload
}

F14 & RButton::KeyHistory ; Or ListHotkeys, but this seems more useful

; Stupid mind shortcut for Alt+A to middle click
!a::Send("{MButton}")

; Make combinator keys that I never use but are otherwise useful as characters
; send the key immediately. These bindings only really make sense in the Latin American keyboard layout

;  Ctrl+Alt+{ to send ^
^!{::Send("{Text}^")

; Ctrl+Alt+} to send `
^!}::Send("{Text}``")

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