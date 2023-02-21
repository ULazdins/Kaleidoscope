import Parsing

let identifierParser = MatchToken<String>(map: { token in
    guard case let .identifier(identifier) = token else { return nil }

    return identifier
})
