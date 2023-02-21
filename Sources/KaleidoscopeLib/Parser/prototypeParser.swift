import Parsing

let prototypeParser = Parse() {
    identifierParser
    getTupleParser(parser: identifierParser)
}.map { (identifier, parameters) in
    Prototype(name: identifier, parameters: parameters)
}
