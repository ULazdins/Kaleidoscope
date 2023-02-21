import Parsing

let functionParser = Parse {
    MatchToken(comparingTo: .keyword(.definition))
    prototypeParser
    expressionParser
    MatchToken(comparingTo: .symbol(.semicolon))
}
.map { (prototype, expression) in
    Function(head: prototype, body: expression)
}
