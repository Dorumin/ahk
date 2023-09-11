
/*
General useful utilities for usage in other autohotkey scripts
Helper functions that are scoped for one application or not generally useful are better kept in that file.

These, even if only used at the moment in one file, should be more widely applicable
and configurable according to their parameters.

Some of these functions can take an argument in the form of a callback.
If possible, these should be provided in the form of an arrow function:

    RestoreMousePosition(false, () => Click(250, 250))
    RestoreMousePosition(true, () => (
        MouseMove(250, 250, 50)
        LongPress('LButton', 15, 50)
    ))

However, this is not always possible. Arrow functions can only execute a single expression.
Even if this can sometimes include multiple of what appear to be *actions*,
this does not include anything in the language. Variable assignments and if statements
are not allowed, or statements in general like loops and declarations.

For these, you should probably make use of hoisting and a named function.
These don't suffer from the annoyances of arrow functions,
but they can be a little more unwieldy and require providing a name.

    Send('^a')
    RestoreClipboard(RestoreClipboardCallback, true)
    RestoreClipboardCallback(clip, *) {
        LogMessage(clip)
    }

For callbacks that take arguments, you may ignore them using a * to capture varargs.
*/

; Since in AHK, everything goes in the global scope anyways, modules are a scam and a social construct
; This file just imports all other utility files for consumers

#Include general.ahk
#Include arrays.ahk
#Include debug.ahk
#Include fs.ahk
#Include input.ahk
#Include os.ahk
#Include strings.ahk