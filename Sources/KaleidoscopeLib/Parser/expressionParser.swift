import Parsing

struct ExpressionOrBinaryExpression: Parser {
    enum Errors: Error {
        case noMatch
    }
    
    func parse(_ input: inout [Token]) throws -> Expression {
        var mutable = input
        
        let expression = try plainExpressionParser.parse(&mutable)
        
        guard let `operator` = try? operatorParser.parse(&mutable) else {
            input = mutable
            return expression
        }
        
        let expression2 = try self.parse(&mutable)
        
        input = mutable
        return .binary(lhs: expression, operator: `operator`, rhs: expression2)
    }
    
}

let expressionParser = ExpressionOrBinaryExpression()
