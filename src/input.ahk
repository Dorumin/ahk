#Include strings.ahk

; Hold a key for a specified duration, and delay after.
; For delay around, just use sleep. idgaf. This is just the most common use case
LongPress(which, duration, after := 0) {
    SendQueue(
        Format("{{}{} down{}}", which),
        duration,
        Format("{{}{} up{}}", which),
        after
    )
}

SendQueue(commands*) {
    for command in commands {
        if IsNumber(command) {
            Sleep(command)
        } else {
            Send(command)
        }
    }
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

    CallSafe(callback, A_Clipboard, old_clipboard)
    final_clipboard := A_Clipboard

    A_Clipboard := old_clipboard

    return final_clipboard
}

class KeyHolder {
    timer := Timer()
    callback := -1
    wait_until := -1

    __New(buttons, increment := 50, max_delay := 250) {
        this.buttons := buttons
        this.increment := increment
        this.max_delay := max_delay
    }

    Pressed(modifiers := '') {
        this.wait_until := Max(this.wait_until, A_TickCount)
        this.wait_until += this.increment
        this.wait_until := Min(this.wait_until, A_TickCount + this.max_delay)

        if this.timer.IsRunning() {
            return
        }

        Send(StrJoin(ArrayMap(this.buttons, (btn, _*) => '{' . btn . ' down}')))

        this.timer.Start()

        this.callback := () => this.OnTimer()
        SetTimer(this.callback, this.increment)
    }

    OnTimer() {
        ; LogMessage('KeyHolder timer ticked')

        if this.wait_until > A_TickCount {
            return
        }

        Send(StrJoin(ArrayMap(this.buttons, (btn, _*) => '{' . btn . ' up}')))

        ; LogMessage('KeyHolder Timer ended')
        SetTimer(this.callback, 0)
        this.timer.Reset()
    }
}


MouseShiftHeld() {
    return GetKeyState('ScrollLock', 'P')
}
