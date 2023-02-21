import Parsing

func getTupleParser<T>(parser: some Parser<[Token], T>) -> AnyParser<[Token], [T]> {
    Parse {
        MatchToken(comparingTo: .symbol(.leftParenthesis))
        Many(
            element: { parser },
            separator: { MatchToken(comparingTo: .symbol(.comma)) },
            terminator: { MatchToken(comparingTo: .symbol(.rightParenthesis)) }
        )
    }.eraseToAnyParser()
}
