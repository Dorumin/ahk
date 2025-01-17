LogsEnabled := true

; Send a message to log.txt for debugging
LogMessage(text) {
    global LogsEnabled

    if not LogsEnabled {
        return
    }

    date_string := Format("{}-{}-{} {}:{}:{}.{}", A_Year, A_Mon, A_MDay, A_Hour, A_Min, A_Sec, A_MSec)

    indented_text := StrReplace(text, '`n', '`n' RepeatString(' ', StrLen(date_string) + 1))

    try {
        FileAppend(date_string " " indented_text "`n", A_ScriptDir "\log.log")
    }
}

debug_gui_shown := false
debug_gui := Gui('+Resize +AlwaysOnTop', 'Debug view')
debug_text := debug_gui.AddText('', 'Blah blah blah whatever whatever')
debug_text.Move(0, 0, 500, 200)

; Show a message onto an always on top window
; For debugging that requires viewing of latest rapidly-updating values
DebugView(message) {
    global debug_gui_shown

    if not debug_gui_shown {
        debug_gui.Show()
        debug_gui.Move( , , 500, 300)
        debug_gui_shown := true
    }

    debug_text.Text := message
}

FormatObjectProps(obj) {
    s := ''

    for key, value in obj.OwnProps() {
        s .= Format('{}: {}`n', key, value)
    }

    return s
}
