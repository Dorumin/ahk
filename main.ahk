#Requires AutoHotkey v2.0

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Increase hotkey interval (for touchpad scrolling, and other stuff)
A_MaxHotkeysPerInterval := 300

KeyHistory(500)

; AHI
#Include lib/AutoHotInterception/AutoHotInterception.ahk

global AHI := AutoHotInterception()

; GDip
#Include lib/GDip/GDip.ahk

CGdip.Startup()

#Include src/all.ahk
#Include slices/global.ahk
#Include slices/explorer.ahk
#Include slices/tabbing.ahk
#Include slices/windowing.ahk
#Include slices/vsc.ahk
#Include slices/opera.ahk
#Include slices/discord.ahk
#Include slices/notepadplusplus.ahk
#Include slices/paintdotnet.ahk
#Include slices/vlc.ahk
#Include slices/ageofempires.ahk
#Include slices/illusion.ahk
#Include slices/dst.ahk
#Include slices/bg3.ahk
#Include slices/sv.ahk

; REFERENCE (for my bad memory):
; ^ = Ctrl
; + = Shift
; ! = Alt
; # = Win
