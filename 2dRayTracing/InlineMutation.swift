infix operator <-

func <- <T>(_ item: T, mutate: (inout T) -> Void) -> T {
    var mutableItem = item
    mutate(&mutableItem)
    return mutableItem
}

func <- <T>(_ object: T, mutate: (T) -> Void) -> T where T: AnyObject {
    mutate(object)
    return object
}
