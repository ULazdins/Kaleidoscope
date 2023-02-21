import Parsing

let externalFunctionParser = Parse {
    MatchToken(comparingTo: .keyword(.external))
    prototypeParser
    MatchToken(comparingTo: .symbol(.semicolon))
}
