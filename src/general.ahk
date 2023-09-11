globals := {}
DeclareGlobals(o) {
    for key, value in o.OwnProps() {
        globals.%key% := value
    }
}
