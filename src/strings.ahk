; Repeats `str` `count` times. 0 for an empty string. Useful for command strings.
RepeatString(str, count) {
    if count < 0 {
        throw ValueError("Repeat count is negative, you fucked up")
    }

    joined := ""

    loop count {
        joined .= str
    }

    return joined
}

; Join an array of values with `joiner`
StrJoin(array, joiner := '') {
    joined := ''

    for index, value in array {
        if index != 1 {
            joined .= joiner
        }

        joined .= value
    }

    return joined
}

; Checks whether `str` ends with `suffix`
StrEndsWith(str, suffix, case_sensitive := true) {
    slice := SubStr(str, -StrLen(suffix))

    if case_sensitive {
        return slice == suffix
    } else {
        return slice == suffix
    }
}

; Checks whether `str` starts with `prefix`
StrStartsWith(str, prefix, case_sensitive := true) {
    slice := SubStr(str, 0, StrLen(prefix))

    if case_sensitive {
        return slice == prefix
    } else {
        return slice == prefix
    }
}

SplitLines(str, limit := -1) {
    return StrSplit(str, ["`r`n", "`n"], , limit)
}
