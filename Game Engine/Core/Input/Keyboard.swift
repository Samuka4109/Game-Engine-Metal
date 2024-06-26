class Keyboard {
    
    private static var KEY_COUNT: Int = 256
    private static var keys = [Bool].init(repeating: false, count: KEY_COUNT)
    
    public static func SetKeyPressed(_ keyCode: UInt16, isON: Bool) {
        keys[Int(keyCode)] = isON
    }
    
    public static func IsKeyPressed(_ keyCode: Keycodes) -> Bool{
        return keys[Int(keyCode.rawValue)]
    }
}
