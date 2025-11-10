#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe blender.exe")

*F16::Send('{Shift down}{MButton down}')
*F16 up::Send('{MButton up}{Shift up}')

#HotIf
