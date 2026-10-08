/**
 * Calls a function given a set of parameters without worrying about how many parameters it itself takes
 * Effectively akin to the assignability behavior of functions with fewer params in typescript to more params
 * 
 * @param {Func} callback Function with unknown parameters to call
 * @param {Any} params
 */
CallSafe(callback, params*) {
    if callback.IsVariadic or callback.MaxParams >= params.Length {
        return callback(params*)
    } else if callback.MaxParams < params.Length {
        params.Length := callback.MaxParams
        return callback(params*)
    }

    throw Error("Uncaught CallSafe")
}

/**
 * Attempt to find an index via callback function. Returns 1-indexed item, 0 if missing
 * 
 * @param {Array} array
 * @param {Func} findfn
 */
ArrayFindIndex(array, findfn) {
    for index, value in array {
        if CallSafe(findfn, value, index) {
            return index
        }
    }

    return 0
}

/**
 * Returns true if the closure returns true for any item, false otherwise
 * 
 * @param {Array} array
 * @param {Func} findfn
 */
ArrayAny(array, findfn) {
    return ArrayFindIndex(array, findfn) != 0
}

/**
 * Returns true if the closure returns true for all items, false otherwise
 * 
 * @param {Array} array
 * @param {Func} findfn
 */
ArrayAll(array, findfn) {
    return ArrayFindIndex(array, (params*) => not CallSafe(findfn, params*)) == 0
}

/**
 * Attempts to find an item in an array by index. If missing, throws an error, because ahk has no null values
 * 
 * @param {Array} array
 * @param {Func} findfn
 */
ArrayFind(array, findfn) {
    index := ArrayFindIndex(array, findfn)

    if index {
        return array[index]
    } else {
        throw IndexError('ArrayFind did not find a value.')
    }
}

/**
 * Find the index of a value in an array
 * 
 * @param {Array} array
 * @param {Any} search_value
 */
ArrayIndexOf(array, search_value) {
    return ArrayFindIndex(array, (item, _*) => item == search_value)
}

/**
 * Check whether an array includes a needle value, by equality
 * 
 * @param {Array} array
 * @param {Any} search_value
 */
ArrayIncludes(array, search_value) {
    return ArrayIndexOf(array, search_value) != 0
}

/**
 * Call a function for each value in an array. No way to break out, use loops for that
 * 
 * @param {Array} array
 * @param {Func} callback
 */
ArrayForEach(array, callback) {
    for index, value in array {
        CallSafe(callback, value, index)
    }
}

/**
 * Filter an array's values
 * 
 * @param {Array} array
 * @param {Func} filterfn
 */
ArrayFilter(array, filterfn) {
    filtered := []

    for index, value in array {
        if CallSafe(filterfn, value, index) {
            filtered.Push(value)
        }
    }

    return filtered
}

/**
 * Maps an array's values to a new array
 * 
 * @param {Array} array
 * @param {Func} mapper
 */
ArrayMap(array, mapper) {
    mapped := []

    ArrayForEach(array, (item, index) => mapped.Push(CallSafe(mapper, item, index)))

    return mapped
}

/**
 * Returns a shallow copy of a portion of the array from start to end-1
 * 
 * @param {Array} array
 * @param {Number} start
 * @param {Number} end
 */
ArraySlice(array, start := 1, end := "") {
    length := array.Length

    ; Normalize start
    if (start < 0)
        start := length + start + 1
    if (start < 1)
        start := 1

    ; Normalize end
    if (end = "") {
        end := length
    } else if (end < 0) {
        end := length + end + 1
    }

    if (end > length)
        end := length

    if (end < start)
        return []

    sliced := []
    loop end - start + 1 {
        sliced.Push(array[start + A_Index - 1])
    }

    return sliced
}

/**
 * @param {Array} array
 */
ArrayFirst(array) {
    return array[1]
}

/**
 * @param {Array} array
 */
ArrayLast(array) {
    return array[array.Length]
}

/**
 * @param {Number} start
 * @param {Number} end
 * @param {Func} check_fn
 */
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

RepeatArray(array, count) {
    if count < 0 {
        throw ValueError("Repeat count is negative, you fucked up")
    }

    joined := []

    loop count {
        joined.Push(array*)
    }

    return joined
}
