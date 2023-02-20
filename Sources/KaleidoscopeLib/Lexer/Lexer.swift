public final class Lexer {
    /// The plain text, which will be lexed.
    public var substring: Substring
    
    private let transformations: [Transformation] = [
        .lexWhitespace,
        .lexIdentifiersAndKeywords,
        .lexNumbers,
        .lexSpecialSymbolsAndOperators,
        .lexInvalidCharacter
    ]

    /// Creates a lexer for the given text, with a starting position of `0`.
    public init(text: String) {
        self.substring = Substring(stringLiteral: text)
    }
    
    /// Tries to return the next token lexable from the `text`.
    /// If there is a syntactical error in the `text`, an error is thrown.
    /// If there are no more characters to be lexed, `nil` is returned.
    public func nextToken() throws -> Token? {
        for transformation in transformations {
            if let token = try transformation.transform(&substring) {
                return token
            }
        }

        return nil
    }
}
