class PersistedValue {
    key := ''
    value := ''
    serializer := String
    deserializer := Number

    __New(props) {
        this.key := props.key
        this.value := props.value
        this.serializer := props.serialize
        this.deserializer := props.deserialize

        this.Load()
    }

    static GetFile() {
        try {
            return FileRead('./values.txt', 'UTF-8')
        } catch {
            return ''
        }
    }

    static WriteFile(contents) {
        file := FileOpen('./values.txt', 'w', 'UTF-8')
        file.Write(contents)
        file.Close()
    }

    static GetLines() {
        return ArrayFilter(SplitLines(this.GetFile()), (line) => line != "")
    }

    static GetKey(line) {
        return StrSplit(line, ':', , 2)[1]
    }

    static GetValue(line) {
        return Trim(StrSplit(line, ':', , 2)[2])
    }

    Serialize(value) {
        return CallSafe(this.serializer, value)
    }

    Deserialize(string) {
        return CallSafe(this.deserializer, string)
    }

    Load() {
        try {
            ParseLine(line) {
                key := PersistedValue.GetKey(line)
                value := PersistedValue.GetValue(line)

                if key == this.key {
                    this.value := this.Deserialize(value)
                }
            }
            ArrayForEach(PersistedValue.GetLines(), ParseLine)
        }
    }

    Set(value) {
        this.value := value

        filtered := ArrayFilter(PersistedValue.GetLines(), (line) => PersistedValue.GetKey(line) != this.key)
        filtered.Push(this.key ": " this.Serialize(this.value))

        PersistedValue.WriteFile(StrJoin(filtered, '`n'))
    }

    Get() {
        return this.value
    }
}

persisted := PersistedValue({
    key: 'a',
    value: 0,
    serialize: (n) => String(n),
    deserialize: (s) => Number(s)
})
