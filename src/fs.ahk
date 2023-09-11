; Go through a list of file paths and return the first path that exists
; Throws TargetError if no path is found
FindFirstExistingFile(filePaths) {
    for path in filePaths {
        ; FileExist returns a list of attributes, because autohotkey moment
        ; However, an empty string is returned on missing, which is falsy
        if FileExist(path) {
            return path
        }
    }

    throw TargetError("No valid file path in list")
}

; Function for dropping a list of file paths into application matched by a WindowTitle
DropFiles(window, files) {
    memRequired := 0

    for k, v in files {
        memRequired += StrLen(v) + 1
    }

    hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired + 21)
    dropfiles := DllCall("GlobalLock", "ptr", hGlobal)

    offset := 20
    NumPut("uint", 20, dropfiles, 0)

    for k, v in files {
        StrPut(v, dropfiles + offset, StrLen(v), "utf-8")
        offset += StrLen(v) + 1
    }

    DllCall("GlobalUnlock", "ptr", hGlobal)

    PostMessage(0x233, hGlobal, 0,, window)
    DllCall("GlobalFree", "ptr", hGlobal)
}
