#HotIf WinActive("ahk_exe notepad++.exe")

; Notepad++ is superior in that it knows to bind the side mouse buttons to
; tab switching. However, it's cringe in that it's backwards
; (or maybe my mouse is backwards)
XButton1:: {
    Send("^{PgDn}")
}

XButton2:: {
    Send("^{PgUp}")
}

XButton1 up::
XButton2 up:: {
    ; nun (n++'s keybinds trigger on release)
}
#HotIf