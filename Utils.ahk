
/*
General useful utilities for usage in other autohotkey scripts
Helper functions that are scoped for one application or file are better kept in that file.

These, even if only used at the moment in one file, should be more generally applicable
and configurable according to their parameters.

Some of these functions can take an argument in the form of a callback.
If possible, these should be provided in the form of an arrow function:

    RestoreMousePosition(false, () => Click(250, 250))
    RestoreMousePosition(true, () => (
        MouseMove(250, 250, 50)
        LongPress('LButton', 15, 50)
    ))

However, this is not always possible. Arrow functions can only execute a single expression.
Even if this can sometimes include multiple of what appear to be *actions*,
this does not include anything in the language. Variable assignments and if statements
are not allowed, or statements in general like loops and declarations.

For these, you should probably make use of hoisting and a named function.
These don't suffer from the annoyances of arrow functions,
but they can be a little more unwieldy and require providing a name.

    Send('^a')
    RestoreClipboard(RestoreClipboardCallback, true)
    RestoreClipboardCallback(clip, *) {
        LogMessage(clip)
    }

For callbacks that take arguments, you may ignore them using a * to capture varargs.
*/

LogsEnabled := true

; Send a message to log.txt for debugging
LogMessage(text) {
    global LogsEnabled

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

; Repeats `str` `count` times. 0 for an empty string. Good for command strings.
RepeatString(str, count) {
    if count < 0 {
        throw ValueError("Repeat count is negative, you fucked up")
    }

    joined := ""

    loop count {
        joined .= str
    }

    return joined
}

; Go through a list of file paths and return the first path that exists
; Throws TargetError if no path is found
FindFirstExistingFile(filePaths) {
    for path in filePaths {
        ; FileExist returns a list of attributes, because autohotkey moment
        ; However, an empty string is returned on missing, which is falsy
        if FileExist(path) {
            return path
        }
    }

    throw TargetError("No valid file path in list")
}

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

; Show a notification for a short while
TrayTipTimeout(ms, message, title := "") {
    TrayTip(message, title)
    SetTimer(HideTrayTip, -ms)
}

; Function for dropping a list of file paths into application matched by a WindowTitle
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