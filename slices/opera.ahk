#HotIf WinActive("ahk_exe opera.exe")

; Remap some alt/ctrl + arrow key shortcuts to tab rotating
F17::
F24::
ScrollLock & WheelDown::
^+Up::
!Right:: {
	Send("^{Tab}")
}

F16::
F21::
ScrollLock & WheelUp::
^+Down::
!Left:: {
	Send("^+{Tab}")
}

; Remap buttons below the scroll wheel to zoom
Pause::^+
Insert::^-

; Forwards and backwards, full circle
ScrollLock & WheelLeft::Send('{ScrollLock up}{XButton1}')
ScrollLock & WheelRight::Send('{ScrollLock up}{XButton2}')

#HotIf