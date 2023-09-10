#Requires AutoHotkey v2.0

; DetectHiddenWindows 1
#MaxThreadsPerHotkey 10

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Increase hotkey interval (for touchpad scrolling, and other stuff)
A_MaxHotkeysPerInterval := 300

; AHI
#Include AutoHotInterception\AutoHotInterception.ahk

global AHI := AutoHotInterception()

#Include Utils.ahk
#Include Explorer.ahk
#Include Tabbing.ahk
#Include Windowing.ahk
#Include VSC.ahk
#Include Opera.ahk
#Include Discord.ahk
#Include Notepad++.ahk
#Include PaintNET.ahk
#Include VLC.ahk
#Include AgeOfEmpires.ahk
#Include Illusion.ahk
#Include DST.ahk
#Include BG3.ahk
#Include SV.ahk

; REFERENCE (for my bad memory):
; ^ = Ctrl
; + = Shift
; ! = Alt
; # = Win

; Disable F1, almost always useless and pressed by accident
; Can be reactivated on a window-per-window basis
F1::return

; Reload the script when developing or it janks out
F14 & LButton::
!F5::Reload

F14 & RButton::KeyHistory ; Or ListHotkeys, but this seems more useful

; Stupid mind shortcut for Alt+A to middle click
!a::Send("{MButton}")

; Make combinator keys that I never use but are otherwise useful as characters
; send the key immediately. These bindings only really make sense in the Latin American keyboard layout

;  Ctrl+Alt+{ to send ^
^!{::Send("{Text}^")

; Ctrl+Alt+} to send `
^!}::Send("{Text}``")
