#HotIf WinActive("ahk_exe AoE2DE_s.exe")

F2::
^q:: {
    Send("+,")
}

F1::Send('.')
^F1::Send('+.')

^a::Send('^+h')

^s::Send('^+b') ; Barracks
^d::Send('^+a') ; Archery
^f::Send('^+l') ; Stables
^g::Send('^+k') ; Siege

#HotIf