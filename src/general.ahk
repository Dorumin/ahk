globals := {}
DeclareGlobals(o) {
    for key, value in o.OwnProps() {
        globals.%key% := value
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