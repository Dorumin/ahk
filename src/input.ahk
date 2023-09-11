; Hold a key for a specified duration, and delay after.
; For delay around, just use sleep. idgaf. This is just the most common use case
LongPress(which, duration, after := 0) {
    Send(Format("{{}{} down{}}", which))
    Sleep(duration)
    Send(Format("{{}{} up{}}", which))
    Sleep(after)
}

; Matcher like WinActive, useful in #HotIf condition
MouseIsOver(WinTitle) {
    MouseGetPos( , , &WindowID)

    return WinExist(WinTitle " ahk_id " WindowID)
}

; Store the mouse position, run a function and bring the mouse back
;
; The `blocking` parameter determines whether to block mouse input while the callback runs
RestoreMousePosition(blocking, callback) {
    if blocking {
        BlockInput("MouseMove")
    }

    x := 0
    y := 0
	MouseGetPos(&x, &y)

    ; Let's hope this callback doesn't throw! Else our mouse is stuck!
    callback()
    MouseMove(x, y, 0)

    if blocking {
        BlockInput("MouseMoveOff")
    }
}

; Store and restore the clipboard between executing a callback function.
; Remember to call ClipWait in your function.
;
; You will almost always do some combination of ctrl+c and ClipWait, likely at the start of `callback`
; For this common usage, you can use the `copy` argument.
RestoreClipboard(callback, copy := false) {
    old_clipboard := A_Clipboard
    A_Clipboard := ""

    if copy {
        Send('^c')
        ClipWait(2)
    }

    callback(A_Clipboard, old_clipboard)

    A_Clipboard := old_clipboard
}