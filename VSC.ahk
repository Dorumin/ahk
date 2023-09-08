#HotIf WinActive("ahk_exe Code.exe")

; Bind mouse button to tab switching
; By default, VSC maps ctrl+tab and ctrl+shift+tab to some tab picker that is sorted by most recently used
; This eats ass, but whatever, we can get the good behavor with the default windows hotkeys ctrl+page up and down
; No need to modify VSC keybindings, autohotkey reigns king
F16::Send('^{PgUp}')
F17::Send('^{PgDn}')

#HotIf