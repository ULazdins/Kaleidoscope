import Parsing

let programParser = Parse {
    Many(
        into: Program(),
        { accumulator, newElement in
            accumulator = accumulator.merge(with: newElement)
        },
        element: {
            OneOf {
                expressionParser.map({ Program(expressions: [$0]) })
                externalFunctionParser.map({ Program(externals: [$0]) })
                functionParser.map({ Program(functions: [$0]) })
            }
        }
    )
    End<[Token]>()
}
