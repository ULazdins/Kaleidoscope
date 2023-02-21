import Parsing

let externalFunctionParser = Parse {
    Token.keyword(.external)
    prototypeParser
    Token.symbol(.semicolon)
}
