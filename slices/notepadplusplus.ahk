#HotIf WinActive("ahk_exe notepad++.exe")

; Notepad++ is superior in that it knows to bind the side mouse buttons to
; tab switching. However, it's cringe in that it's backwards
; (or maybe my mouse is backwards)
F17::
Insert:: {
    Send("^{PgDn}")
}

F16::
Pause:: {
    Send("^{PgUp}")
}

Insert up::
Pause up:: {
    ; nun (n++'s keybinds trigger on release, we have to disable them)
}
#HotIf