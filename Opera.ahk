; Remap some alt/ctrl + arrow key shortcuts to tab rotating
#HotIf WinActive("ahk_exe opera.exe")
F14::
Home & WheelDown::
!Right:: {
	Send("^{Tab}")
}

F13::
Home & WheelUp::
!Left:: {
	Send("^+{Tab}")
}

XButton1::Send("^-")
XButton2::Send("^{+}")
#HotIf