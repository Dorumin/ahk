#Requires AutoHotkey v2.0

PI := 3.14159265358979

Atan2(y, x) {
    if x > 0 {
        return Atan(y / x)
    } else if x < 0 and y >= 0 {
        return Atan(y / x) + PI
    } else if x < 0 and y < 0 {
        return Atan(y / x) - PI
    } else if x == 0 and y > 0 {
        return PI / 2
    } else if x == 0 and y < 0 {
        return -PI / 2
    } else {
        return 0
    }
}

Hypot(x, y) {
    return Sqrt(x*x + y*y)
}

IsAngleBetween(angle, min, max) {
    if (min <= max) {
        return angle >= min && angle <= max
    } else {
        return angle >= min || angle <= max
    }
}

PixelAround(x, y, offset, degrees) {
    adjusted_degrees := degrees - 90

    radians := (adjusted_degrees / 180.0) * 3.1415

    cosa := Cos(radians)
    sina := Sin(radians)

    newX := x + offset * cosa
    newY := y + offset * sina

    return [newX, newY]
}
