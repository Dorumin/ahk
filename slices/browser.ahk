#Include ../src/all.ahk

GroupAddTree({
    AnyBrowser: {
        Opera: 'ahk_exe opera.exe',
        Brave: 'ahk_exe brave.exe'
    }
})

#HotIf WinActive("ahk_group AnyBrowser")

; Remap some alt/ctrl + arrow key shortcuts to tab rotating, and side mouse
F17::
^+Up:: ; ctrl+shift up
!Right:: {
	Send("^{Tab}")
}

F16::
^+Down:: ; ctrl+shift down
!Left:: {
	Send("^+{Tab}")
}

; Remap buttons below the scroll wheel to zoom
Pause::^+
Insert::^-

; Forwards and backwards, full circle
ScrollLock & WheelLeft:: {
    Send('{ScrollLock up}{XButton1}')
    Sleep(150)
}
ScrollLock & WheelRight:: {
    Send('{ScrollLock up}{XButton2}')
    Sleep(150)
}

WheelLeft:: {
    Send('{MButton}')
    Sleep(250)
}

F20:: {
    url := RestoreClipboard((*) => (
        ; messy. URL bar sometimes fails to select or to copy in time.
        Send('^l')
        Sleep(100)
        Send('^l')
        Sleep(100)
        Send('^l')
        Sleep(100)
        Send('^c')
        Sleep(100)
        Send('^c')
        Sleep(100)
        Send('^c')
        ClipWait(1)
    ))

    RegExMatch(url, '/status/(?<tweet_id>\d+)', &tweet_id_match)

    WinActivate('ahk_exe Discord.exe')
    Sleep(100)

    Send('^f')
    Send('^a')
    SendInput(tweet_id_match.tweet_id)
    Send('{Enter}')
}

F19:: {
    ; Click media, bottom right corner
    browser_window_id := WinActive()
    discord_window_id := WinGetID('ahk_exe Discord.exe')
    Click(1075, 575)
    Sleep(100)

    tweet_photo_url := RestoreClipboard((*) => (
        ; messy. URL bar sometimes fails to select or to copy in time.
        Send('^l')
        Sleep(100)
        Send('^l')
        Sleep(100)
        Send('^c')
        Sleep(100)
        Send('^c')
        ClipWait(1)
    ))

    RegExMatch(tweet_photo_url, '(?<id>\d+)/photo/(?<photo_count>\d)', &match)
    tweet_id := match.id
    photo_count := Number(match.photo_count)
    tweet_base_url := RegExReplace(tweet_photo_url, '/photo/\d', '')

    WinActivate(discord_window_id)
    Sleep(100)

    Send('^f{Escape}{Escape}')

    ; Select text area regardless of current focused input
    Send('{Tab}')
    ; Send('{Escape}')
    Send('{Escape}')
    Sleep(100)

    ; SendInput used for similar performance to copy/pasting
    SendInput('<')
    SendInput(tweet_base_url)
    SendInput('>+{Enter}')
    Sleep(100)

    ; Focus back on Opera and wait for the tweet media viewer to load (top-left close x to appear)
    WinActivate(browser_window_id)
    PixelWait(88, 125, [ '0xFFFFFF' ], 3)

    ; Select the first image in the set
    Loop photo_count - 1 {
        Click(40, 525)
    }

    ; The media viewer takes a hot second to process the movement
    Sleep(500)

    file_paths := []

    ; Relay each pic to Discord
    Loop photo_count {
        photo_number := A_Index

        ; Copy the image with the context menu, fucky input handling
        A_Clipboard := ""
        Click(875, 500, 'R')
        PixelWait(1000, 635, [ '0x1C2221' ], 1)
        MouseMove(1000, 635)
        Sleep(100)
        ; Context menu sometimes misses clicks, long press
        LongPress('LButton', 150)
        ClipWait(3, true)

        file_path := Format("{}\{}.{}.{}.{}", A_Desktop, "twimg", tweet_id, photo_number, "jpg")
        Download(A_Clipboard, file_path)

        ; Can't use DropFiles on shitty electron apps; fuck standard messages I guess
        ; Batch to clipboard later
        file_paths.Push(file_path)

        ; ; Back to Discord
        ; WinActivate(discord_window_id)
        ; Sleep(100)

        ; Send('^v')
        ; Sleep(300)

        ; ; Back to Opera
        ; WinActivate(browser_window_id)
        ; Sleep(100)

        ; Click to see next image; if last image, close media viewer
        Click(1445, 525)
        Sleep(100)
    }

    ; MsgBox(StrJoin(file_paths, '`n'))

    ; Sleep(2000)
    ClipboardSetFiles(file_paths)

    ; Focus on Discord window after all is said and done and pasted and inspected
    WinActivate(discord_window_id)
    Sleep(100)

    ; Paste batch files from clipboard
    Send('^v')
}

#HotIf
