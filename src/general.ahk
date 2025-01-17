#Include debug.ahk

globals := {}
DeclareGlobals(o) {
    for key, value in o.OwnProps() {
        globals.%key% := value
    }
}

GroupAddMultiple(group, titles*) {
    for title in titles {
        GroupAdd(group, title)
    }
}

GroupAddTree(group_tree, group_name := '') {
    if not IsObject(group_tree) {
        throw TypeError('Tree must be an object')
    }

    if group_tree is Array {
        throw TypeError('Should never be passed an array directly')
    }

    for key, value in group_tree.OwnProps() {
        if value is String {
            ; Create leaf group with selector
            GroupAdd(key, value)
            ; Add leaf to parent
            GroupAdd(group_name, Format('ahk_group {}', key))
        } else if value is Array {
            if group_name != '' {
                throw TypeError('Self-references should be at the top level')
            }

            ; Extend an existing group with arbitrary sub-groups
            ; Mostly to break out of the inherent tree structure of objects,
            ; and to be able to create self-referential trees

            for index, sub_group in value {
                GroupAdd(key, Format('ahk_group {}', sub_group))
            }
        } else if IsObject(value) {
            GroupAddTree(value, key)

            if group_name != '' {
                GroupAdd(group_name, Format('ahk_group {}', key))
            }
        } else {
            throw TypeError(Format('Unrecognized type for tree value. Key: {}. Value type: {}. Value: {}', key, value, Type(value)))
        }
    }
}

class Timer {
    startTicks := -1

    Reset() {
        this.startTicks := -1
    }

    Start(update := false) {
        if not update and this.IsRunning() {
            throw Error('Timer is already running. Reset it first')
        }

        this.startTicks := A_TickCount
    }

    IsRunning() {
        return this.startTicks != -1
    }

    Elapsed() {
        if A_TickCount < this.startTicks {
            ; The 50 day uptime limit was reached, try to extend this by handling wrap around
            return A_TickCount + 4294967296 - this.startTicks
        } else {
            return A_TickCount - this.startTicks
        }
    }
}

BinarySearch(start, end, check_fn) {
    left := start
    right := end

    while left <= right {
        pivot := Floor((left + right) / 2)
        status := check_fn(pivot)

        if status == 'less' {
            right := pivot - 1
        } else if status == 'more' {
            left := pivot + 1
        } else {
            return pivot
        }
    }

    throw IndexError('No value found by search')
}

Clamp(minimum, number, maximum) {
    return Min(maximum, Max(minimum, number))
}