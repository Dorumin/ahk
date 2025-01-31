#HotIf WinActive("ahk_exe paintdotnet.exe")

; This tiny little hack lets you pan with the middle mouse button on images
; that were just opened and are considered unpannable.
; Images that you haven't yet zoomed in/out of, or scrolled, or otherwise
; moved or altered in some way (except editing, funnily enough) can't be panned
; with the middle mouse button.
; The fix is just to do an instant zoom out and zoom in, so nothing changes,
; but you can pan now
~MButton:: {
    Send("{Ctrl down}{WheelDown}{WheelUp}{Ctrl up}")
}

; Tab switching with side buttons
F16::^+Tab
F17::^Tab

; Center line mouse buttons for image zooming
Pause::^+
Insert::^-

; Alternative, more fine grained zooming
F16 & WheelUp::^WheelUp
F16 & WheelDown::^WheelDown

; Mouse alt button and center line button to pick current hovered color
; Returns you to the paintbrush tool. Idk how to return to previous tool
ScrollLock & Insert:: {
    Send('k') ; Select color picker
    Send('{LButton}') ; Click hovered button
    Send('b') ; Select paint brush
}

; Adjust zoom to image
ScrollLock & MButton:: {
    Send('^a') ; Ctrl+a to select whole image
    Send('+^b') ; Ctrl+shift+b to zoom to selection

    ; Send escape a few times to clear the selection
    Send('{Escape}')
    Send('{Escape}')
    Send('{Escape}')
}

; Adjust brush size with MAlt + scroll wheel
ScrollLock & WheelUp:: {
    RestoreMousePosition(true, () => (
        MouseMove(235, 110)
        Send('{WheelUp up}')
    ))
}

ScrollLock & WheelDown:: {
    RestoreMousePosition(true, () => (
        MouseMove(235, 110)
        Send('{WheelDown up}')
    ))
}

; Undo/Redo with MAlt+side wheel buttons
ScrollLock & WheelLeft::^z
ScrollLock & WheelRight::^y

; Merge all layers and save
; Currently just saves one layer lol I'm lazy
F18:: {
    Send('^m^s')
    Sleep(550)
    Send('^z')
}

#HotIf