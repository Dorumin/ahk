#Include general.ahk
#Include arrays.ahk

PixelWait(x, y, colors, timeout := -1) {
    start := Timer()

    Loop {
        pixel_color := PixelGetColor(x, y, 'RGB')

        if ArrayIncludes(colors, pixel_color) {
            return true
        }

        if timeout != -1 and start.Elapsed() > timeout {
            return false
        }
    }
}

PixelToHex(color) {
    return Format('#{:06x}', color - 0xff000000)
}
