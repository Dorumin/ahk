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

    PostMessage(0x233, hGlobal, 0, , window)
    DllCall("GlobalFree", "ptr", hGlobal)
}

ClipboardSetFiles(files, DropEffect := "Copy") {
    ; FilesToSet - list of fully qualified file pathes separated by "`n" or "`r`n"
    ; DropEffect - preferred drop effect, either "Copy", "Move" or "" (empty string)
    Static TCS := 2 ; size of a TCHAR
    Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
    Static DropEffects := Map(1, 1, 2, 2, "Copy", 1, "Move", 2)
    ; -------------------------------------------------------------------------------------------------------------------
    ; Count files and total string length
    TotalLength := 0
    FileArray := []
    For index, file in files {
        If (Length := StrLen(file)) {
            FileArray.Push({ Path: file, Len: Length + 1 })
        }
        TotalLength += Length
    }
    FileCount := FileArray.Length
    If !(FileCount && TotalLength) {
        Return False
    }
    ; -------------------------------------------------------------------------------------------------------------------
    ; Add files to the clipboard
    If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard") {
        ; HDROP format ---------------------------------------------------------------------------------------------------
        ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
        hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * TCS, "UPtr")
        pDrop := DllCall("GlobalLock", "Ptr", hDrop)
        Offset := 20
        NumPut("uint", Offset, pDrop + 0) ; DROPFILES.pFiles = offset of file list
        NumPut("uint", 1, pDrop + 16)     ; DROPFILES.fWide = 0 --> ANSI, fWide = 1 --> Unicode

        For Each, File In FileArray {
            Offset += StrPut(File.Path, pDrop + Offset, File.Len, 'UTF-16')
        }

        DllCall("GlobalUnlock", "Ptr", hDrop)
        DllCall("SetClipboardData", "UInt", 0x0F, "UPtr", hDrop) ; 0x0F = CF_HDROP
        ; Preferred DropEffect format ------------------------------------------------------------------------------------
        If (DropEffect := DropEffects[DropEffect]) {
            ; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
            ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
            hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
            pMem := DllCall("GlobalLock", "Ptr", hMem)
            NumPut('uchar', DropEffect, pMem + 0)
            DllCall("GlobalUnlock", "Ptr", hMem)
            DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
        }

        DllCall("CloseClipboard")
        Return True
    }

    Return False
}
