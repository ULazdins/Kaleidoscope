import Parsing

let programParser = expressionParser
    .map { expressions in
        Program(externals: [], functions: [], expressions: expressions)
    }
