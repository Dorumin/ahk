; Alt+Shift+E for screenshot, next frame in VLC
#HotIf WinActive("ahk_exe vlc.exe")
!+e:: {
	Send("{Shift down}s{Shift up}")
	Sleep(150)
	Send("e")
}

F21:: {
    Send("^h+!T")
}
#HotIf
