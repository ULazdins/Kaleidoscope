import Foundation

extension Transformation {
    /// The set of characters allowed as an identifier's head.
    private static let identifierHead: CharacterSet = CharacterSet
        .letters
        .union(CharacterSet(charactersIn: "_"))

    /// The set of characters allowed as an identifier's body.
    private static let identifierBody: CharacterSet = identifierHead.union(.decimalDigits)
    
    static let lexIdentifiersAndKeywords = Transformation { string -> Token? in
        var buffer = ""
        
        guard
            let firstChar = string.first,
            firstChar.isPartOf(identifierHead)
        else {
            return nil
        }
        
        buffer.append(firstChar)
        string = string.dropFirst()
        
        while true {
            guard
                let next = string.first,
                next.isPartOf(identifierBody)
            else {
                break
            }
            
            buffer.append(next)
            string = string.dropFirst()
        }
        
        if let keyword = Token.Keyword(rawValue: String(buffer)) {
            return .keyword(keyword)
        } else {
            return .identifier(buffer)
        }
    }
}
