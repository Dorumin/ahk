; Remap some alt/ctrl + arrow key shortcuts to tab rotating
#HotIf WinActive("ahk_exe opera.exe")
F14::
ScrollLock & WheelDown::
^+Up::
!Right:: {
	Send("^{Tab}")
}

F13::
ScrollLock & WheelUp::
^+Down::
!Left:: {
	Send("^+{Tab}")
}

XButton1::Send("^-")
XButton2::Send("^{+}")
#HotIf