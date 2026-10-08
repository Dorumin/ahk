#Include ../src/all.ahk

#HotIf WinActive('ahk_exe WindowsTerminal.exe')

F16::^+Tab
F17::^Tab
WheelLeft:: LongPress('MButton', 250)

F19::^LButton

ScrollLock & MButton::^LButton

#HotIf
