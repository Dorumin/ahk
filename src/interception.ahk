ListenInterceptionDevices(filter, callback) {
    seen_devices := []

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
        devices := AHI.GetDeviceList()

        ArrayForEach(devices, (device, _*) => DispatchDevice(device))
    }

    SetTimer(CheckAdd, 15000)
    CheckAdd()
}
