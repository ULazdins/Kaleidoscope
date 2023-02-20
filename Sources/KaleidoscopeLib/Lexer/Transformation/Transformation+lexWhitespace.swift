extension Transformation {
    /// Consumes whitespace (and newlines). Always returns `nil`.
    static let lexWhitespace = Transformation { string in
        while string.first?.isPartOf(.whitespacesAndNewlines) == true {
            string = string.dropFirst()
        }
        
        return nil
    }
}
