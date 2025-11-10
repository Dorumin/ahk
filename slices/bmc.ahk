#Include ../src/all.ahk

#HotIf WinActive("ahk_exe MonkeyCity-Win.exe")

1::RestoreMousePosition(true, () => (
    MouseMove(290, 855)
    LongPress('LButton', 35, 0)
))

2::RestoreMousePosition(true, () => (
    MouseMove(290 + 69 * 1, 855)
    LongPress('LButton', 35, 0)
))

3::RestoreMousePosition(true, () => (
    MouseMove(290 + 69 * 2, 855)
    LongPress('LButton', 35, 0)
))

4::RestoreMousePosition(true, () => (
    MouseMove(290 + 69 * 3, 855)
    LongPress('LButton', 35, 0)
))

5::RestoreMousePosition(true, () => (
    MouseMove(290 + 69 * 4, 855)
    LongPress('LButton', 35, 0)
))

a::z
s::x

z::,
x::.

+z:: {
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
}

+x:: {
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)
}

Place(hotkey, x, y, left, right, sleepms) {
    if hotkey != '' {
        LongPress(hotkey, 50, 150)
    }

    if x != 0 and y != 0 {
        MouseMove(x, y)
        Sleep(50)
        LongPress('LButton', 50, 150)
    }

    Loop left {
        LongPress(',', 50, 150)
    }

    Loop right {
        LongPress('.', 50, 150)
    }

    Sleep(sleepms)
}

Navigate(left, x, y) {
    LogMessage(Format("Navigate {} {} {}", left, x, y))

    MouseMove(100, 1000)
    LongPress('LButton', 50, 500)
    LongPress('LButton', 50, 500)
    LongPress('LButton', 50, 500)

    PixelWait(1400, 600, [ 0xB04800 ], -1, 1)
    Sleep(500)

    MouseMove(1300, 565)
    LongPress('LButton', 50, 1500)

    MouseMove(1800, 900)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 50)
    LongPress('WheelDown', 50, 500)
    LongPress('LButton', 50, 1500)

    if left != 0 {
        MouseMove(1250, 500)
        Sleep(50)
        Send('{LButton down}')
        Sleep(50)
        Loop 10 {
            MouseMove(-200, 0, 50, 'R')
            Sleep(20)
        }
        Send('{LButton up}')
        Sleep(500)
    }

    MouseMove(x, y)
    LongPress('LButton', 50, 1000)

    MouseMove(1000, 900)
    LongPress('LButton', 50, 7000) ; 5000
}

Boomer() {
    Place('v', 875, 160, 2, 0, 0)
    Place('r', 900, 660, 0, 2, 0)

    MouseMove(875, 160)

    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)
    Sleep(15000)

    Place('', 0, 0, 0, 1, 0)
    Sleep(10000)

    Place('v', 875, 300, 2, 0, 0)
}

Dart() {
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)

    ; Place('q', 875, 783 - 45 * 0, 0, 3, 150)
    ; Place('q', 875, 783 - 45 * 1, 0, 3, 150)
    ; Place('q', 875, 783 - 45 * 2, 0, 3, 150)
    ; Place('q', 875, 783 - 45 * 3, 2, 3, 15000)
    ; Place('q', 875, 783 - 45 * 4, 2, 3, 15000)
    ; Place('q', 875, 783 - 45 * 5, 2, 3, 10000)
    ; Place('q', 875, 783 - 45 * 6, 2, 3, 5000)
    ; Place('q', 875, 783 - 45 * 7, 0, 3, 4000)
    ; Place('q', 875, 783 - 45 * 8, 0, 3, 3000)
    ; Place('q', 875, 783 - 45 * 9, 2, 3, 3000)
    ; Place('q', 875, 783 - 45 * 11, 2, 3, 2000)
    ; Place('q', 875, 783 - 45 * 12, 2, 3, 150)

    Place('q', 900, 783 - 45 * 0, 0, 3, 100)
    Click(420, 1050)
    Sleep(50)
    Place('q', 850, 783 - 45 * 0, 0, 3, 150)
    Place('q', 900, 783 - 45 * 1, 2, 3, 150)
    Place('q', 850, 783 - 45 * 1, 2, 3, 13000)
    Place('q', 900, 783 - 45 * 2, 2, 3, 12000)
    Place('q', 850, 783 - 45 * 2, 2, 3, 11000)
    ; Place('q', 900, 783 - 45 * 3, 2, 3, 5000)
    ; Place('q', 850, 783 - 45 * 3, 0, 3, 4000)
    ; Place('q', 900, 783 - 45 * 4, 0, 3, 3000)
    ; Place('q', 850, 783 - 45 * 4, 2, 3, 2000)
    ; Place('q', 900, 783 - 45 * 5, 2, 3, 1000)
    ; Place('q', 850, 783 - 45 * 5, 2, 3, 150)
    Place('q', 1000, 783 - 45 * 1, 2, 3, 5000)
    Place('q', 750, 783 - 45 * 1, 2, 3, 4000)
    Place('q', 1050, 783 - 45 * 1, 2, 3, 3000)
    Place('q', 700, 783 - 45 * 1, 2, 3, 2000)
    ; Place('q', 1100, 783 - 45 * 1, 2, 3, 1000)
    ; Place('q', 650, 783 - 45 * 1, 2, 3, 150)
    Place('q', 650, 783 - 45 * 1, 2, 3, 1000)
    Place('q', 600, 783 - 45 * 1, 2, 3, 150)

    PixelWait(900, 920, [ 0xA33A00 ], -1, 1)
    MouseMove(900, 900)
    LongPress('LButton', 50, 150)
    Sleep(1500)
}

Ninja() {
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)

    Place('t', 875, 700, 3, 2, 150)
    Sleep(32000)

    Place('', 0, 0, 1, 0, 22000)
    ; Place('t', 666, 610, 3, 2, 9000)
    ; Place('t', 875, 645, 3, 2, 8000)
    Place('t', 740, 730, 3, 2, 8000)
    Place('', 0, 0, 1, 0, 150)
    PixelWait(900, 920, [ 0xA33A00 ], -1, 1)

    ; Sleep(1000)

    MouseMove(900, 900)
    LongPress('LButton', 50, 150)

    Sleep(1500)
}

Plane() {
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)
    LongPress('Space', 50, 150)

    Place('c', 450, 185, 2, 1, 150)
    Place('f', 640, 185, 4, 0, 150)
    Place('f', 450, 375, 3, 0, 160000)
    Place('', 0, 0, 1, 0, 150)

    PixelWait(900, 920, [ 0xA33A00 ], -1, 1)
    MouseMove(900, 900)
    LongPress('LButton', 50, 150)

    Sleep(1500)
}

F16:: {
    LongPress('BS', 50, 50)
    LongPress('m', 50, 50)
    LongPress('LButton', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress(',', 50, 50)
    LongPress(',', 50, 50)

    RestoreMousePosition(true, () => (
        MouseMove(290, 855)
        LongPress('LButton', 35, 0)
    ))
    Sleep(50)

    LongPress('LButton', 50, 50)
}

F17:: {
    LongPress('BS', 50, 50)
    LongPress('y', 50, 50)
    LongPress('LButton', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)
    LongPress('.', 50, 50)

    RestoreMousePosition(true, () => (
        MouseMove(290, 855)
        LongPress('LButton', 35, 0)
    ))
    Sleep(50)

    LongPress('LButton', 50, 50)
}

F20:: Dart()
+!D::
^F20:: {
    Loop {
        Navigate(true, 800, 400)
        Dart()
    }
}

F21:: {
    c := Number(PixelGetColor(1400, 600, 'RGB Alt'))

    MsgBox(Format('#{:06x}', c))
    PixelWait(1400, 600, [ 0xffffff ], -1, 1)
    MsgBox(Format('#{:02x}', c >> 8 & 0xff - c >> 8 & 0xff))
    MsgBox(Format('#{:02x}', (c >> 8) & 0xff - (c >> 8) & 0xff))
}

F22:: Plane()
+!P::
^F22:: {
    Loop {
        Navigate(false, 600, 700)
        Plane()
    }
}

F23:: Ninja()
+!N::
^F23:: {
    Loop {
        Navigate(true, 800, 400)
        Ninja()
    }
}

F24:: Boomer()
+!B::
^F24:: {
    Navigate(false, 1250, 700)
    Boomer()
}

COMMON := 0xaed02f
UNCOMMON := 0xde3737
RARE := 0xbf2fcf
LEGENDARY := 0xFED229
REWARD := 0x008CF5
WILD := 0x8B2974

ColorToLetter(c1, c2) {
    prefix := ''

    if ColorNear(c2, WILD, 2) {
        prefix := 'w'
    }

    if ColorNear(c1, COMMON, 2) {
        return prefix . 'c'
    } else if ColorNear(c1, UNCOMMON, 2) {
        return prefix . 'u'
    } else if ColorNear(c1, RARE, 2) {
        return prefix . 'r'
    } else if ColorNear(c1, LEGENDARY, 2) {
        return prefix . 'l'
    } else if ColorNear(c1, REWARD, 2) {
        return 'x' ; no custom
    } else {
        return 'x'
    }
}

Numpad0:: {
    first := PixelGetColor(625, 635, 'RGB Alt') ; 625 / 633
    second := PixelGetColor(900, 635, 'RGB Alt') ; 920
    third := PixelGetColor(1190, 635, 'RGB Alt') ; 1207
    fourth := PixelGetColor(1480, 635, 'RGB Alt')

    letters := [
        ColorToLetter(first, PixelGetColor(625, 320, 'RGB Alt')),
        ColorToLetter(second, PixelGetColor(890, 320, 'RGB Alt')),
        ColorToLetter(third, PixelGetColor(1190, 320, 'RGB Alt')),
        ColorToLetter(fourth, PixelGetColor(1480, 320, 'RGB Alt')),
    ]

    ok := true

    if ArrayIncludes(letters, 'x') {
        Send('{PrintScreen}')
        Sleep(100)
        ok := false
    }

    ; MsgBox(Format("{} {} {} {}", letters[1], letters[2], letters[3], letters[4]))

    Send('{Alt down}{Tab}{Alt up}')
    Sleep(100)
    Send(Format("{}{Tab}{}{Tab}{}{Tab}{}{Tab}{Down}{Ctrl down}{Left}{Ctrl up}", letters[1], letters[2], letters[3], letters[4]))

    if ok {
        Sleep(100)
        Send('{Alt down}{Tab}{Alt up}')
        Sleep(150)
        MouseMove(500, 500)
        Sleep(150)
        LongPress('LButton', 50, 150)
        MouseMove(800, 500)
        LongPress('LButton', 50, 150)
        MouseMove(1100, 500)
        LongPress('LButton', 50, 150)
        MouseMove(1400, 500)
        LongPress('LButton', 50, 2000)

        if (
            ColorNear(PixelGetColor(930, 420, 'RGB Alt'), 0xffffff, 2)
            or ColorNear(PixelGetColor(930, 440, 'RGB Alt'), 0xffffff, 2)
            or ColorNear(PixelGetColor(950, 420, 'RGB Alt'), 0xffffff, 2)
            or ColorNear(PixelGetColor(950, 440, 'RGB Alt'), 0xffffff, 2)
         ) {
            MouseMove(950, 440)
            LongPress('LButton', 50, 2000)

            MouseMove(500, 500)
            Sleep(150)
            LongPress('LButton', 50, 150)
            MouseMove(800, 500)
            LongPress('LButton', 50, 150)
            MouseMove(1100, 500)
            LongPress('LButton', 50, 150)
            MouseMove(1400, 500)
            LongPress('LButton', 50, 150)
        }
    }
}

#HotIf
