; Attempt to find an index via callback function. Returns 1-indexed item, 0 if missing
ArrayFindIndex(array, findfn) {
    for index, value in array {
        if findfn(value, index) {
            return index
        }
    }

    return 0
}

; Attempts to find an item in an array by index. If missing, throws an error, because ahk has no null values
ArrayFind(array, findfn) {
    index := ArrayFindIndex(array, findfn)

    if index {
        return array[index]
    } else {
        throw IndexError('ArrayFind did not find a value.')
    }
}

; Find the index of a value in an array
ArrayIndexOf(array, search_value) {
    return ArrayFindIndex(array, (item, *) => item == search_value)
}

; Check whether an array includes a needle value, by equality
ArrayIncludes(array, search_value) {
    return ArrayIndexOf(array, search_value) != 0
}

; Call a function for each value in an array. No way to break out, use loops for that
ArrayForEach(array, callback) {
    for index, value in array {
        callback(value, index)
    }
}

ArrayFilter(array, filterfn) {
    filtered := []

    for index, value in array {
        if filterfn(value, index) {
            filtered.Push(value)
        }
    }

    return filtered
}

ArrayMap(array, mapper) {
    mapped := []

    ArrayForEach(array, (item, index) => mapped.Push(mapper(item, index)))

    return mapped
}