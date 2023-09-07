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
Media_Next:: {
    Send("^{Tab}")
}

Media_Prev:: {
    Send("^+{Tab}")
}

#HotIf