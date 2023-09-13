global SELECTED_COLOR := "0xF2F3F5"

global GUILD_CLICK_X := 40
global DM_CLICK_Y := 55
global DM_CHECK_POS := [0, 55]

global START_CHECK_Y := 130
global CHECK_SKIP_Y := 63

global lastClickedGuildHeight := -1

#HotIf WinActive("ahk_exe Discord.exe")
; Disable Ctrl+R in Discord (refresh) (why)
^r::
; Disable Ctrl+P in Discord (open pins)
^p::
; Disable Ctrl+U in Discord (toggle members list)
^u::
; Disable Ctrl+Shift+A in Discord (collapse all categories)
^+a::return

; Fix Ctrl+Alt+Right (but it's kinda laggy)
^!Right:: {
    global lastClickedGuildHeight

    dm_color := PixelGetColor(DM_CHECK_POS[1], DM_CHECK_POS[2], "RGB")
    is_on_dm := dm_color == SELECTED_COLOR

    start_time := A_TickCount

    if is_on_dm {
        y := START_CHECK_Y
        found := false

        Loop {
            if y >= A_ScreenHeight {
                break
            }

            color := PixelGetColor(0, y, "RGB")

            if color == SELECTED_COLOR {
                RestoreMousePosition(true, () => Click(GUILD_CLICK_X, y))
                lastClickedGuildHeight := y
                found := true
                break
            }

            y := y + CHECK_SKIP_Y
        }

        if not found and lastClickedGuildHeight != -1 {
            RestoreMousePosition(true, () => Click(GUILD_CLICK_X, lastClickedGuildHeight))
        }

        ; MsgBox("Took " (A_TickCount - start_time) "ms to find white dollop")
    } else {
        RestoreMousePosition(true, () => Click(GUILD_CLICK_X, DM_CLICK_Y))
    }
}

; Iterate over channels with the mouse wheel
Pause::!Up
ScrollLock & WheelUp::!Up

Insert::!Down
ScrollLock & WheelDown::!Down

; Iterate over guilds with side buttons
F16::^!Down
F17::^!Up

ScrollLock & F16::!Down
ScrollLock & F17::!Up

WheelRight::^!Right

#HotIf