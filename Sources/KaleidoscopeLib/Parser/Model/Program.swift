public struct Program {
    var externals: [Prototype] = []
    var functions: [Function] = []
    var expressions: [Expression] = []
}

public struct Prototype {
    let name: String
    let parameters: [String]
}

public struct Function {
    let head: Prototype
    let body: Expression
}

public indirect enum Expression {
    case number(Double)
    case variable(String)
    case binary(lhs: Expression, operator: Operator, rhs: Expression)
    case call(String, arguments: [Expression])
    case `if`(condition: Expression, then: Expression, else: Expression)
}

extension Program: Equatable { }
extension Prototype: Equatable { }
extension Function: Equatable { }
extension Expression: Equatable { }

extension Program {
    func merge(with other: Program) -> Program {
        Program(
            externals: self.externals + other.externals,
            functions: self.functions + other.functions,
            expressions: self.expressions + other.expressions
        )
    }
}
