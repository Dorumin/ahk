LogsEnabled := true

; Send a message to log.txt for debugging
LogMessage(text) {
    global LogsEnabled

    if not LogsEnabled {
        return
    }

    DateString := Format("{}-{}-{} {}:{}:{}.{}", A_Year, A_Mon, A_MDay, A_Hour, A_Min, A_Sec, A_MSec)

    FileAppend(DateString " " text "`n", A_ScriptDir "\log.txt")
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
