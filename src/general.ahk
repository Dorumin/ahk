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

GroupAddTree(group, group_name := '') {
    if not IsObject(group) {
        throw TypeError('Tree must be an object')
    }

    if group is Array {
        throw TypeError('Should never be passed an array directly')
    }

    for key, value in group.OwnProps() {
        if value is Array {
            for index, sub_group in value {
                GroupAdd(key, 'ahk_group ' sub_group)
            }
        } else if IsObject(value) {
            GroupAddTree(value, key)

            if group_name {
                GroupAdd(group_name, 'ahk_group ' key)
            }
        } else {
            if group_name {
                GroupAdd(group_name, value)
            }
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