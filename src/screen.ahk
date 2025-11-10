#Include general.ahk
#Include arrays.ahk

PixelWait(x, y, colors, timeout := -1, fallibility := 0) {
    start := Timer()
    start.Start()

    if ArrayAny(colors, (color) => Type(color) == 'String') {
        throw Error('PixelWait() called with array of strings')
    }

    Loop {
        pixel_color := Number(PixelGetColor(x, y, 'RGB Alt'))

        ColorMatches(color) {
            return ColorNear(color, pixel_color, fallibility)
        }

        if ArrayAny(colors, ColorMatches) {
            return true
        }

        ; if ArrayIncludes(colors, pixel_color) {
        ;     return true
        ; }

        if timeout != -1 and start.Elapsed() > timeout {
            return false
        }
    }
}

ColorNear(color1, color2, fallibility) {
    return Abs((color1 & 0xff) - (color2 & 0xff)) <= fallibility
        && Abs(((color1 >> 8) & 0xff) - ((color2 >> 8) & 0xff)) <= fallibility
        && Abs(((color1 >> 16) & 0xff) - ((color2 >> 16) & 0xff)) <= fallibility
}

ColorToHex(color) {
    return Format('#{:06x}', color - 0xff000000)
}
