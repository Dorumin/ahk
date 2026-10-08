#Requires AutoHotkey v2.0

hWnd := WinGetID("ahk_exe WindowsTerminal.exe")

if (hWnd) {
    DllCall("FlashWindow", "UInt", hWnd, "Int", True)
}

