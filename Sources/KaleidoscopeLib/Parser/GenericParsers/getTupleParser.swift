import Parsing

func getTupleParser<T>(parser: some Parser<[Token], T>) -> AnyParser<[Token], [T]> {
    Parse {
        Token.symbol(.leftParenthesis)
        Many(
            element: { parser },
            separator: { Token.symbol(.comma) },
            terminator: { Token.symbol(.rightParenthesis) }
        )
    }.eraseToAnyParser()
}
