import Parsing

let functionParser = Parse {
    Token.keyword(.definition)
    prototypeParser
    expressionParser
    Token.symbol(.semicolon)
}
.map { (prototype, expression) in
    Function(head: prototype, body: expression)
}
