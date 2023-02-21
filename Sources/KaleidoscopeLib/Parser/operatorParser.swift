import Parsing

let operatorParser = MatchToken<Operator>(map: { token in
    guard case let .operator(`operator`) = token else { return nil }
    return `operator`
})
