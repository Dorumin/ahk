; These are built-in, not touching that shit

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; This file was created to turn spamming certain keys into one continous press
; It seems backwards, but it was made because TeamViewer is unable to hold down keys
; Probably because they're stupid

; Another way to phrase it is "emulate long presses from many fast presses"
; In this case, <200ms between each press will be kept held
MIN_MS_BETWEEN_PRESS = 200

; We need this because... yeah, holding down keys presses them lots of times. Surprise!
#MaxHotkeysPerInterval 10000

; Oh man, lookat this beautiful array creation syntax!!
keys := []
keys[1] := "w"
keys[2] := "a"
keys[3] := "s"
keys[4] := "d"
keys[5] := "g"

; This is what I came up with to replace clearTimeout, you just assign the timestamp for when you called it
; and pass it to the callback. Then the callback checks if it and the value in this object are the same,
; and if they are, it does stuff!
; Paired with an "is this pressed" map for the purpose of having multiple keys held down
pressedTimes := Object()
isPressedMap := Object()

; Dynamically add the hotkey overrides
; The $ is needed to avoid recursively calling oneself
for _, key in keys {
    Hotkey, $%key%, HoldSpam
    Hotkey, $%key% up, OnKeyUp
}

; Get a relative monotonic counter in ms
NikeTicks() {
    result := A_TickCount
    return result
}

; Timeout callback
LiftKey(key, callTime, pressedTimes) {
    global MIN_MS_BETWEEN_PRESS, isPressedMap

    currentLastTime := pressedTimes[key]

    if (currentLastTime == callTime) {
        if (isPressedMap[key] != "yes") {
            Send, {%key% up}
        } else {
            Send, {%key% down}
            callback := Func("LiftKey").bind(key, callTime, pressedTimes)
            SetTimer, %callback%, -%MIN_MS_BETWEEN_PRESS%
        }
    }
}

; Subroutines, these should probably just be functions... Oh well!
return

HoldSpam:
    pressed := StrReplace(A_ThisHotkey, "$", "")
    currentTime := NikeTicks()


    Send, {%pressed% down}
    callback := Func("LiftKey").bind(pressed, currentTime, pressedTimes)
    SetTimer, %callback%, -%MIN_MS_BETWEEN_PRESS%

    isPressedMap[pressed] := "yes"
    pressedTimes[pressed] := currentTime
return

OnKeyUp:
    pressed := Trim(StrReplace(StrReplace(A_ThisHotkey, "$", ""), "up", ""))

    isPressedMap[pressed] := "no"
return
