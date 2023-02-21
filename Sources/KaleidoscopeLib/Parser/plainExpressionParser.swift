import Parsing

private func getExpressionParser() -> AnyParser<[Token], Expression> {
    var expression: AnyParser<[Token], Expression>!
    
    let parenthesizedExpressionParser = Parse {
        Token.symbol(.leftParenthesis)
        Lazy { expression! }
        Token.symbol(.rightParenthesis)
    }
    
    let ifThenElseParser = Parse {
        Token.keyword(.if)
        Lazy { expression! }
        Token.keyword(.then)
        Lazy { expression! }
        Token.keyword(.else)
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

    expression = OneOf {
        parenthesizedExpressionParser
        numberParser.map(Expression.number)
        ifThenElseParser
        callExpressionParser
        variableParser
    }.eraseToAnyParser()
    
    return expression
}

let plainExpressionParser = getExpressionParser()
