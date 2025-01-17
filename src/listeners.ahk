#Include all.ahk

window_watcher_callbacks := []
window_watcher_current_ids := []
window_watcher_first := true

AddWindowWatcherCallback(callback) {
    global window_watcher_callbacks

    window_watcher_callbacks.Push(callback)
}

SetTimer(WindowWatcher, 250)
WindowWatcher() {
    global window_watcher_current_ids, window_watcher_first

    current_ids := WinGetList()

    added_ids := ArrayFilter(current_ids, (id, _*) => not ArrayIncludes(window_watcher_current_ids, id))
    removed_ids := ArrayFilter(window_watcher_current_ids, id => not ArrayIncludes(current_ids, id))

    window_watcher_current_ids := current_ids

    added_events := ArrayMap(added_ids, id => WindowWatcherEvent('added', id))
    removed_events := ArrayMap(removed_ids, id => WindowWatcherEvent('removed', id))

    ArrayForEach(added_events, (event) => ArrayForEach(window_watcher_callbacks, cb => cb(event)))
    ArrayForEach(removed_events, (event) => ArrayForEach(window_watcher_callbacks, cb => cb(event)))

    window_watcher_first := false
}

class WindowWatcherEvent {
    type := ''
    id := -1
    title := ''
    exe := ''
    first := false

    __New(type, window_id) {
        this.type := type
        this.id := window_id
        this.first := window_watcher_first
        try {
            this.exe := WinGetProcessPath(this.id)
            this.title := WinGetTitle(this.id)
        }
    }
}