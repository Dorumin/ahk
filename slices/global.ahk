#Include ../src/all.ahk

; Disable F1, almost always useless and pressed by accident
; Can be reactivated on a window-per-window basis
F1:: return

; Reload the script when developing or it janks out
F14 & LButton::
!F5:: {
    ; Set slow title match mode for matching controls text. It's OK because we're gonna reload the script anyways
    SetTitleMatchMode('Slow')
    ; All warnings and errors seem to have a reload button
    ; But only errors have a "The script was not reloaded; the old version will remain in effect." message
    error_windows := WinGetList('ahk_exe AutoHotkey64.exe', '&Reload')

    for window_id in error_windows {
        WinClose(window_id)
    }

    Reload
}

F14 & RButton:: {
    ; Or ListHotkeys, but this seems more useful
    KeyHistory
    ; Scroll to the end in the hotkey list. End by itself doesn't do it
    Send('^{End}')
}

; Stupid mind shortcut for Alt+A to middle click
!a::MButton

; Make combinator keys that I never use but are otherwise useful as characters
; send the key immediately. These bindings only really make sense in the Latin American keyboard layout

;  Ctrl+Alt+{ to send ^
^!{:: Send("{Text}^")

; Ctrl+Alt+} to send `
^!}:: Send("{Text}``")

AddWindowWatcherCallback(WindowEventCallback)
WindowEventCallback(event) {
    if event.type != 'added' or event.exe != 'C:\Windows\explorer.exe' {
        return
    }

    class := WinGetClass(event.id)

    ; LogMessage("window event {}, {}", event.type, class)

    if class != 'CabinetWClass' {
        return
    }

    ; Maximize all explorers; weirdly inconsistent in windows
    WinMaximize(event.id)

    explorer_windows := WinGetList('ahk_exe explorer.exe ahk_class CabinetWClass')
    if explorer_windows.Length == 1 {
        if explorer_windows[1] != event.id {
            MsgBox('failed validation: only one explorer window open, but is not added window.')
        }

        ; new explorer window is ours, we gucci
        return
    }

    existing_explorer_id := ArrayFilter(explorer_windows, (id) => id != event.id)[1]
    text := WinGetText(event.id)

    ; Just Windows paths (DriveLetter ":\" ...)
    ; Also avoids new windows problem where the title starts with "Non Client Input Sink Window"
    RegExMatch(text, 'm)^(?<address>[A-Z]:.+)$', &address_match)

    if address_match == '' {
        LogMessage('new-explorer-window: did not match, full: ' text)
        return
    } else {
        LogMessage('new-explorer-window: ' address_match.address)
    }

    address := address_match.address

    old_clipboard := A_Clipboard
    A_Clipboard := address

    WinClose(event.id)
    WinActivate(existing_explorer_id)
    Sleep(100)

    HOME_GUID := "::{F874310E-B6B7-47DC-BC84-B9E6B38F5903}"

    loop {
        ; TODO: Debug alternative input methods, long presses or SendInput/SendEvent
        SendQueue('{Ctrl down}', 50, '{t down}', 50, '{t up}', 50, '{Ctrl up}', 250)

        output := ExecPS3(Format("
        (
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class NativeMethods {
    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
}
"@

$WM_COMMAND = 0x0111
$NEW_TAB_COMMAND = 0xA21B

# This does not show up in the .Windows iterator. Fail
# [NativeMethods]::SendMessage({}, $WM_COMMAND, [IntPtr]::Zero + $NEW_TAB_COMMAND, [IntPtr]::Zero)

$shellApp = New-Object -ComObject Shell.Application
$windows = $shellApp.Windows()

foreach ($window in $windows) {
    if ($window.Name -eq "File Explorer" -or $window.FullName -like "*explorer.exe") {
        $path = $window.Document.Folder.Self.Path

        Write-Output $path

        if ($path -like '{}') {
            $window.Navigate("{}")
        }
    }
}
        )",
            existing_explorer_id, HOME_GUID, address))

        has_home := ArrayAny(SplitLines(output), (line) => line == HOME_GUID)

        LogMessage("new-explorer-window has home: " has_home)

        if has_home {
            break
        }
    }
}

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
        WinActivate() ; LastFoundWindow
        Send("{Tab}^t")
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
        Sleep(150)
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
    } else {
        Run("C:\Windows\explorer.exe", , "Hide")
        WinWait("ahk_exe explorer.exe ahk_class CabinetWClass")
        WinActivate()
    }
}

; Bring back a bluetooth shortcut removed in Windows 11
; Win+K used to bring up a device list, now it brings up cast. Wtf
; Now, Win+B will toggle bluetooth connectivity and open the device list.
#b:: {
    Send("#a")

    ; Can't pick it up...?
    ; exists := WinWait("ahk_class Windows.UI.Core.CoreWindow", , 2)

    ; Fuck it, hardcode coords
    ; Sleep(250)
    ; RestoreMousePosition(true, () => (
    ;     Click(1650, 565)
    ;     Click(1710, 565)
    ; ))
}

; It's only funny a couple times
; Requires editing registry:
; HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisableLockWorkstation
; Ctrl+Alt+Delete still works to change user (win+L) or log out
#l:: return

is_dragging := false
start_drag_x := -1
start_drag_y := -1
drag_move_total_x := -1
drag_move_total_y := -1

ListenInterceptionDevices(
    (device) => device.IsMouse,
    (device) => (
        AHI.SubscribeMouseButton(device.id, 0, false, OnMouseButtonPressDragListener)
        AHI.SubscribeMouseMoveRelative(device.id, false, OnMouseMoveDragListener)
    )
)

OnMouseButtonPressDragListener(pressed) {
    global start_drag_x, start_drag_y, drag_move_total_x, drag_move_total_y, is_dragging

    if pressed {
        is_dragging := true
        drag_move_total_x := 0
        drag_move_total_y := 0
        MouseGetPos(&start_drag_x, &start_drag_y)
    } else {
        MouseGetPos(&end_drag_x, &end_drag_y)
        drag_move_total_x := end_drag_x - start_drag_x
        drag_move_total_y := end_drag_y - start_drag_y
        is_dragging := false
    }
}

OnMouseMoveDragListener(x, y) {
    global drag_move_total_x, drag_move_total_y

    if is_dragging {
        drag_move_total_x += x
        drag_move_total_y += y
    }
}

F14 & Insert:: {
    MsgBox(Abs(drag_move_total_x) + Abs(drag_move_total_y))
    if Abs(drag_move_total_x) + Abs(drag_move_total_y) < 100 {
        return
    }
    Send('{MButton up}')
    Send('{F14 up}')

    RestoreMousePosition(true, () => (
        MouseMove(start_drag_x, start_drag_y)
        Send('{LButton down}')
        Sleep(25)
        SendMode('Event')
        MouseMove(start_drag_x + drag_move_total_x, start_drag_y + drag_move_total_y, 2)
        Send('{LButton up}')
    ))
}

YoutubeDownload() {
    Send('^{BS}')
    Sleep(10)

    copied := Trim(A_Clipboard)

    position := RegExMatch(copied, "www\.youtube\.com\/watch\?v=.{11}|youtu\.be\/.{11}|youtube.com\/shorts\/.{11}")

    if position == 0 {
        MsgBox('youtubedl did not pick up a copied youtube url. Bad invocation?')
        ; return
    }

    WinActivate('ahk_exe opera.exe')

    Click(1790, 75) ; Open extensions dropdown

    x := ''
    y := ''

    loop 20 {
        ImageSearch(&x, &y, 1400, 100, 1900, 900, "*11 ./assets/getcookiestxt.png")
        Sleep(50)

        if x != '' && y != '' {
            break
        }
    }

    if x == '' || y == '' {
        MsgBox('Failed to find cookies.txt extension')
        return
    }

    Click(x, y) ; Open cookies export

    Sleep(800)

    Click(1500, 275) ; Export all cookies (to not have to open yt)

    from_cookies := A_Desktop "/../Downloads/cookies.txt"
    to_cookies := A_Desktop "/../Code/.tests/files/cookies.txt"

    while !FileExist(from_cookies) {
        Sleep(50)
    }

    ; Delay a little bit to hide random errors in the browser (virus scan failed, download interrupted, etc)
    ; Alternatively could copy and then remove it later
    Sleep(1000)

    ; Update cookies.txt file, overwriting it
    FileMove(from_cookies, to_cookies, true)

    ; (bp) doesn't work here for some reason
    result := ExecPS3(
        'yt-dlp.exe --js-runtimes node -o "$env:USERPROFILE/Downloads/%(title)s [%(id)s].%(ext)s" --cookies "' to_cookies '" "' copied '"; sleep 5',
        true, true)
}

:X*B0:youtubedl:: YoutubeDownload()
