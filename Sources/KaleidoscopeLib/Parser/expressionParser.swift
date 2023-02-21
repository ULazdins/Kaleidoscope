import Parsing

private func getExpressionParser() -> AnyParser<[Token], [Expression]> {
    var expression: AnyParser<[Token], Expression>!
    
    let parenthesizedExpressionParser = Parse {
        MatchToken(comparingTo: .symbol(.leftParenthesis))
        Lazy { expression! }
        MatchToken(comparingTo: .symbol(.rightParenthesis))
    }
    
    let ifThenElseParser = Parse {
        MatchToken(comparingTo: .keyword(.if))
        Lazy { expression! }
        MatchToken(comparingTo: .keyword(.then))
        Lazy { expression! }
        MatchToken(comparingTo: .keyword(.else))
        Lazy { expression! }
    }.map({ (condition, thenExpression, elseExpression) in
        return Expression.if(condition: condition, then: thenExpression, else: elseExpression)
    })
    
    let callExpressionParser: AnyParser<[Token], Expression> = Parse {
        identifierParser
        getTupleParser(parser: Lazy { expression! })
    }.map { (identifier, expressions) in
        Expression.call(identifier, arguments: expressions)
    }.eraseToAnyParser()
    
    struct OperatorMatchParser: Parser {
        enum No: Error {
            case yolo
        }
        
        func parse(_ input: inout [Token]) throws -> Operator {
            guard
                let first = input.first,
                case let .operator(`operator`) = first
            else {
                throw No.yolo
            }
            
            input = Array(input.dropFirst())
            return `operator`
        }
    }

    expression = OneOf {
        parenthesizedExpressionParser
        numberParser.map(Expression.number)
        ifThenElseParser
        callExpressionParser
        // variable, identifier
    }.eraseToAnyParser()
    
    let binaryExpression = Parse {
        expression!
        OperatorMatchParser()
        expression!
    }.map { (lhs, operation, rhs) in
        Expression.binary(lhs: lhs, operator: operation, rhs: rhs)
    }.eraseToAnyParser()
    
    return Many {
        OneOf {
            binaryExpression
            expression!
        }
    }.eraseToAnyParser()
}

let expressionParser = getExpressionParser()
