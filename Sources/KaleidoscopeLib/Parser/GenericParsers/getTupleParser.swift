import Parsing

func getTupleParser<T>(parser: some Parser<[Token], T>) -> AnyParser<[Token], [T]> {
    Parse {
        MatchToken(comparingTo: .symbol(.leftParenthesis))
        Many(
            into: [T](),
            { accumulator, nextFragment in accumulator = accumulator + [nextFragment] },
            element: { parser },
            separator: { MatchToken(comparingTo: .symbol(.comma)) }
        )
        MatchToken(comparingTo: .symbol(.rightParenthesis))
    }.eraseToAnyParser()
}
