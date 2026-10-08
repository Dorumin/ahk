#Requires AutoHotkey v2.0

#Include ../src/all.ahk

#HotIf WinActive('ahk_exe Palworld-Win64-Shipping.exe')

ScrollLock & WheelUp::
ScrollLock & WheelDown::Click()

*F16::SendQueue('{WheelUp}', 30, '{WheelDown}', 100)
*F17::SendQueue('{WheelUp}', 30, '{WheelDown}', 200, '{LButton down}', 60, '{LButton up}')
; *F16::SendQueue('{WheelDown}', 100)
; *F17::SendQueue('{WheelUp}', 100)
F18::AddFirst15FromPalbox()
AddFirst15FromPalbox() {
    SendQueue(
        () => Click('R', 690 + 80 * 0, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 1, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 2, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 3, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 4, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 5, 250 + 80 * 0),
        50,
        () => Click('R', 690 + 80 * 0, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 1, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 2, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 3, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 4, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 5, 250 + 80 * 1),
        50,
        () => Click('R', 690 + 80 * 0, 250 + 80 * 2),
        50,
        () => Click('R', 690 + 80 * 1, 250 + 80 * 2),
        50,
        () => Click('R', 690 + 80 * 2, 250 + 80 * 2),
        50,
        '{Escape}'
    )
}
^F18::FeedTeams()
FeedTeams() {
    FeedTeam(starty) {
        LongPress('f', 50, 250)

        Click(400, 690)
        Sleep(50)

        Loop 25 {
            SendQueue('{WheelDown}', 30)
        }

        SendQueue(
            () => Click(400, 690),
            50,
            () => Click('R', 400, starty),
            50,
            () => Click(750, starty),
            150,
            '{Escape}',
            150,
            '{Escape}',
            150,
            '{Escape}',
            150,
            'i',
            800,
            () => Click('R', 225, 225),
            300,
        )

        Loop 5 {
            Click(950, 442 + 103 * (A_Index - 1))

            Sleep(100)
        }

        SendQueue(
            '{Escape}',
            50,
            '{Escape}',
            250
        )
    }

    FeedTeam(400 + 146 * 0)
    FeedTeam(400 + 146 * 1)
    FeedTeam(400 + 146 * 2)
}

scrollbars := Map(
    'mid', [1170, 600],
    'bot', [1170, 850]
)

targets := Map(
    'feybreak', ['mid', 800, 500],
    'rayne', ['mid', 800, 580],
    'moonflower', ['bot', 800, 740]
)

target := 'moonflower'

^F24:: ExpeditionLoop()
ExpeditionLoop() {
    outer:
    Loop {
        LongPress('f', 50, 500)
        LongPress('x', 50, 200)
        LongPress('escape', 50, 200)
        LongPress('f', 50, 500)

        tgt := targets[target]

        MouseMove(scrollbars[tgt[1]]*)

        LongPress('LButton', 50, 200)

        MouseMove(tgt[2], tgt[3])

        Sleep(200)

        LongPress('LButton', 50, 200)

        MouseMove(475, 900)

        Sleep(500)

        LongPress('LButton', 50, 200)

        MouseMove(950, 900)

        Sleep(200)

        LongPress('LButton', 50, 200)

        start := Timer()

        start.Start()

        while start.Elapsed() < (39.1 * 60 * 1000) {
            if not WinActive('ahk_exe Palworld-Win64-Shipping.exe') {
                break outer
            }

            ; LongPress('LShift', 50, 500)

            Sleep(500)
        }
    }
}

f23:: DropEggs()
DropEggs() {
    LongPress('f', 50, 600)

    if PixelIs(1450, 840, [0xb33636], 3) {
        MouseMove(1150, 840)

        ; Sleep(50)

        LongPress('LButton', 50, 50)

        LongPress('Escape', 50, 50)

        return
    }


    MouseMove(1450, 840)

    Sleep(50)

    LongPress('LButton', 50, 150)

    ; MouseMove(950, 870)

    ; Sleep(50)

    ; LongPress('LButton', 50, 150)

    ; LongPress('Escape', 50, 150)
    LongPress('Escape', 50, 150)
    LongPress('Escape', 50, 400)

    MouseMove(1150, 840)
    LongPress('LButton', 50, 150)

    LongPress('Escape', 50)
}

F22::Fish()
Fish() {
    LongPress('f', 600, 600)

    loops := 120

    scan_start := A_TickCount
    min_match := -1
    max_match := -1
    ; For weird bar detections
    min_angle := 10

    While min_match == -1 or max_match == -1 or Abs(min_match - max_match) < min_angle {
        if A_TickCount - scan_start > 4000 {
            return
        }

        bitmap := CGdip.Bitmap.FromScreen()

        Loop loops {
            angle := 360 / loops * A_Index
            coords := PixelAround(960, 320, 105, angle)
            pixel_color := bitmap.GetPixel(coords[1], coords[2])

            ColorMatches(color) {
                return ColorNear(color, pixel_color, 6)
            }

            matched := ArrayAny([0x19dc8c, 0x1DDD8C, 0x24e396], ColorMatches)

            ; LogMessage("angle {} at ({}) was: {}; matched: {}", angle, StrJoin(coords, ', '),  ColorToHex(pixel_color), matched)

            if matched {
                if min_match == -1 {
                    min_match := angle
                    max_match := angle
                } else {
                    min_match := Min(min_match, angle)
                    max_match := Max(max_match, angle)
                }
            }
        }
    }

    capture_time := -1
    bar_angle := -1
    bar_loops := 180

    outer:
    Loop {
        capture_time := A_TickCount
        bitmap := CGdip.Bitmap.FromScreen()

        Loop bar_loops {
            angle := 360 / bar_loops * A_Index
            coords := PixelAround(960, 320, 105, angle)
            pixel_color := bitmap.GetPixel(coords[1], coords[2])

            ColorMatchesBar(color) {
                return ColorNear(color, pixel_color, 5)
            }

            bar_matched := ArrayAny([0xcbb04d, 0xfff68e], ColorMatchesBar)

            ; LogMessage("bar {} at ({}) was: {}; matched: {}", angle, StrJoin(coords, ', '),  ColorToHex(pixel_color), bar_matched)

            if bar_matched {
                bar_angle := angle
                break outer
            }
        }
    }

    LogMessage("range: {}-{}", min_match, max_match)

    circuit_ms := 1333
    lag_offset := 0 ; Bigger = earlier

    Loop {
        elapsed := A_TickCount - capture_time + lag_offset
        current_angle := bar_angle + elapsed * 360 / circuit_ms
        current_angle := Mod(current_angle, 360)

        if IsAngleBetween(current_angle, min_match, max_match) {
            LongPress('f', 10, 50)

            break
        }
    }

    LogMessage("range: {}-{}; bar at {} {}ms ago", min_match, max_match, bar_angle, elapsed)
}

F19::MeasureCycleInterval()
MeasureCycleInterval() {
    bar_loops := 180
    last_bar_angle := -1

    outer:
    Loop {
        capture_time := A_TickCount
        bitmap := CGdip.Bitmap.FromScreen()

        Loop bar_loops {
            angle := 360 / bar_loops * A_Index
            coords := PixelAround(960, 320, 105, angle)
            pixel_color := bitmap.GetPixel(coords[1], coords[2])

            ColorMatchesBar(color) {
                return ColorNear(color, pixel_color, 5)
            }

            bar_matched := ArrayAny([0xcbb04d, 0xfff68e], ColorMatchesBar)

            if bar_matched {
                message := ""

                if last_bar_angle > angle {
                    message := " (reset)"
                }

                LogMessage("bar spotted: {} {}{}", angle, ColorToHex(pixel_color), message)

                last_bar_angle := angle
            }
        }
    }
}

#HotIf
