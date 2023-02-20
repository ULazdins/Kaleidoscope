extension Transformation {
    /// Treats any lexed character as invalid, and throws
    /// `Error.invalidCharacter`.
    /// If there are no characters to be lexed, `nil` is returned.
    static let lexInvalidCharacter = Transformation { string in
        if let character = string.first {
            string = string.dropFirst()
            throw Error.invalidCharacter(character)
        } else {
            return nil
        }
    }
    
    public enum Error: Swift.Error {
        case invalidCharacter(Character)
    }
}
