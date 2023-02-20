struct Transformation {
    let transform: (inout Substring) throws -> Token?
}
