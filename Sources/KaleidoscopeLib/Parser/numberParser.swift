import Parsing

let numberParser = MatchToken<Double> { token in
    guard case let .number(double) = token else { return nil }
    
    return double
}
