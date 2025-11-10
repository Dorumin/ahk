#Requires AutoHotkey v2.0

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; You never know
BlockInput("MouseMoveOff")

; Increase hotkey interval (for touchpad scrolling, and other stuff)
A_MaxHotkeysPerInterval := 300

KeyHistory(500)

#Include src/all.ahk

#Include slices/global.ahk
#Include slices/ageofempires.ahk
#Include slices/bg3.ahk
#Include slices/blender.ahk
#Include slices/bmc.ahk
#Include slices/browser.ahk
#Include slices/bstack.ahk
#Include slices/conhost.ahk
#Include slices/discord.ahk
#Include slices/dst.ahk
#Include slices/explorer.ahk
#Include slices/illusion.ahk
#Include slices/imageglass.ahk
#Include slices/notepadplusplus.ahk
#Include slices/paintdotnet.ahk
#Include slices/spore.ahk
#Include slices/sv.ahk
#Include slices/tabbing.ahk
#Include slices/vlc.ahk
#Include slices/vsc.ahk
#Include slices/windowing.ahk

#Include slices/temp.ahk

; REFERENCE (for my bad memory):
; ^ = Ctrl
; + = Shift
; ! = Alt
; # = Win
