; These are built-in

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; This file was created to turn spamming certain keys into one continous press
; It seems backwards, but it was made because TeamViewer is unable to hold down keys
; Probably because they're stupid

; Another way to phrase it is "emulate long presses from many fast presses"
; In this case, <100ms between each press will be kept held
MIN_MS_BETWEEN_PRESS = 100

; We need this because... yeah, holding down keys presses them lots of times. Surprise!
#MaxHotkeysPerInterval 10000


; Oh man, lookat this beautiful array creation syntax!!
keys := []
keys[1] := "w"
keys[2] := "a"
keys[3] := "s"
keys[4] := "d"

; This is what I came up with to replace clearTimeout, you just assign the timestamp for when you called it
; and pass it to the callback. Then the callback checks if it and the value in this object are the same,
; and if they are, it does stuff!
pressedTimes := Object()

; Dynamically add the hotkey overrides
; The $ is needed to avoid recursively calling oneself
for _, key in keys {
	Hotkey, $%key%, HoldSpam
    Hotkey, $%key% up, DoNothing
}

; Get a relative monotonic counter in ms
NikeTicks() {
    Result := A_TickCount
    return Result
}

; Timeout callback
LiftKey(key, callTime, pressedTimes) {
    currentLastTime := pressedTimes[key]

    if (currentLastTime == callTime) {
        Send, {%key% up}
    }
}

; Subroutines, these should probably just be functions... Oh well!!
return

HoldSpam:
    pressed := StrReplace(A_ThisHotkey, "$", "")
    currentTime := NikeTicks()

    ; This block of code was the first implementation of the "send every X ms"
    ; But using the timeout intrinsics turned out better
    ; Just, shame they don't have a way to clear it with a returned id
    ;
    ; oldTime := pressedTimes[pressed]
    ; elapsed := 0

    ; if (oldTime != "") {
    ;     elapsed := currentTime - oldTime
    ; }

    ; if (elapsed > MIN_MS_BETWEEN_PRESS) {
    ;     Send, {%pressed% down}
    ; }

    Send, {%pressed% down}
    callback := Func("LiftKey").bind(pressed, currentTime, pressedTimes)
    SetTimer, %callback%, -%MIN_MS_BETWEEN_PRESS%

    pressedTimes[pressed] := currentTime
return

; Self documenting code lover
DoNothing:
return
