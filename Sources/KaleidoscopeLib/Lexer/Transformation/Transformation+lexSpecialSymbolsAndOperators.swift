extension Transformation {
    static let lexSpecialSymbolsAndOperators = Transformation { string in
        var buffer = ""
        
        guard let firstChar = string.first else { return nil }
        
        if let specialSymbol = Token.Symbol(rawValue: firstChar) {
            string = string.dropFirst()
            return .symbol(specialSymbol)
        }
        
        if let `operator` = Operator(rawValue: firstChar) {
            string = string.dropFirst()
            return .operator(`operator`)
        }
        
        return nil
    }
}
