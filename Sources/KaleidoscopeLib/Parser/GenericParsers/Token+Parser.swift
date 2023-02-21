import Parsing

extension Token: Parser {
    enum Errors: Error {
        case noMatch
    }
    
    public func parse(_ input: inout [Token]) throws -> Void {
        guard input.first == self else { throw Errors.noMatch }
        
        input = Array(input.dropFirst())
        return Void()
    }
}
