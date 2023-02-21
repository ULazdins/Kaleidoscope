import Parsing

struct MatchToken<T>: Parser {
    enum Errors: Error {
        case noMatch
    }
    
    let map: (Token) -> T?
    
    func parse(_ input: inout [Token]) throws -> T {
        guard
            let first = input.first,
            let match = map(first)
        else {
            throw Errors.noMatch
        }
        
        input = Array(input.dropFirst())
        return match
    }
}

extension MatchToken where T == Void {
    init(comparingTo other: Token) {
        self.init { token in
            return token == other ? Void() : nil
        }
    }
}
