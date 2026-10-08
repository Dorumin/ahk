ListenInterceptionDevices(filter, callback, timeout := 1000 * 60 * 5) {
    ; There is no cleanup of seen_devices, because disconnecting and reconnecting might reuse ids
    ; It's just more convenient to not handle event unregistration
    seen_devices := []
    start := A_TickCount

    DispatchDevice(device) {
        if ArrayIncludes(seen_devices, device.id) {
            return
        }

        seen_devices.Push(device.id)

        if not filter(device) {
            return
        }

        callback(device)
    }

    CheckAdd() {
        if timeout != 0 and (A_TickCount - start) > timeout {
            return
        }

        devices := AHI.GetDeviceList()

        ArrayForEach(devices, (device, _*) => DispatchDevice(device))
    }

    SetTimer(CheckAdd, 15000)
    CheckAdd()
}
