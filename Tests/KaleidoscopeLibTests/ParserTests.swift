import XCTest
import CustomDump
@testable import KaleidoscopeLib

final class ParserTests: XCTestCase {
    func testNoTokens() throws {
        let tokens: [Token] = []
        let program = try programParser.parse(tokens)
        
        XCTAssert(program.externals.isEmpty)
        XCTAssert(program.functions.isEmpty)
        XCTAssert(program.expressions.isEmpty)
    }
    
    func testNumberExpression() throws {
        let tokens: [Token] = [.number(5)]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.number(5)]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testVariableExpression() throws {
        let tokens: [Token] = [.identifier("id")]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.variable("id")]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testInvalidVariableExpression() throws {
        let tokens: [Token] = [
            .identifier("not_id"), .symbol(.leftParenthesis), .symbol(.rightParenthesis)
        ]
        let program = try programParser.parse(tokens)

        XCTAssertFalse(program.expressions.contains(.variable("not_id")))
    }

    func testCallExpressionWithoutParameters() throws {
        let tokens: [Token] = [
            .identifier("run"), .symbol(.leftParenthesis), .symbol(.rightParenthesis)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.call("run", arguments: [])]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testCallExpressionWithParameters() throws {
        let tokens: [Token] = [
            .identifier("run"),
            .symbol(.leftParenthesis),
            .number(1), .symbol(.comma), .number(2),
            .symbol(.rightParenthesis)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.call("run", arguments: [.number(1), .number(2)])]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testCallExpressionWithTrailingComma() {
        let tokens: [Token] = [
            .identifier("run"),
            .symbol(.leftParenthesis),
            .number(1), .symbol(.comma),
            .symbol(.rightParenthesis)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .symbol(.rightParenthesis))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testIfElseExpression() throws {
        let tokens: [Token] = [
            .keyword(.if),   .number(0),
            .keyword(.then), .number(10),
            .keyword(.else), .number(20)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.if(condition: .number(0), then: .number(10), else: .number(20))]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testIfElseExpressionWithMultipleReturnExpressions() {
        let tokens: [Token] = [
            .keyword(.if),   .number(0),
            .keyword(.then), .number(10), .number(15),
            .keyword(.else), .number(20)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .number(15))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testIfElseExpressionMissingReturnExpression() {
        let tokens: [Token] = [
            .keyword(.if),   .number(0),
            .keyword(.then),
            .keyword(.else), .number(10)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .keyword(.else))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testIfElseExpressionMissingElse() {
        let tokens: [Token] = [
            .keyword(.if),   .number(0),
            .keyword(.then), .number(10)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, nil)
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testParenthesizedExpression() throws {
        let tokens: [Token] = [
            .symbol(.leftParenthesis), .number(0), .symbol(.rightParenthesis)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.number(0)]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testNestedParenthesizedExpression() throws {
        let tokens: [Token] = [
            .symbol(.leftParenthesis), .symbol(.leftParenthesis),
            .number(0),
            .symbol(.rightParenthesis), .symbol(.rightParenthesis)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [.number(0)]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testUnbalancedParenthesizedExpression() {
        let tokens: [Token] = [
            .symbol(.leftParenthesis),
            .number(0),
            .symbol(.rightParenthesis), .symbol(.rightParenthesis)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .symbol(.rightParenthesis))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testBinaryExpression() throws {
        let tokens: [Token] = [
            .number(5), .operator(.modulo), .number(2)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [
            .binary(lhs: .number(5), operator: .modulo, rhs: .number(2))
        ]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testBinaryExpressionSequence() throws {
        let tokens: [Token] = [
            .number(3), .operator(.modulo), .number(2), .operator(.plus), .number(1)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [
            .binary(
                lhs: .number(3),
                operator: .modulo,
                rhs: .binary(lhs: .number(2), operator: .plus, rhs: .number(1))
            )
        ]
        XCTAssertNoDifference(program, Program(expressions: expected))
    }

    func testUnbalancedBinaryExpression() {
        let tokens: [Token] = [
            .number(3), .operator(.modulo), .operator(.plus), .number(2)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .operator(.plus))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testHalfBinaryExpression() {
        let tokens: [Token] = [
            .number(3), .operator(.modulo)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, nil)
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testMultipleExpressions() throws {
        let tokens: [Token] = [
            .identifier("do"), .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .number(0),
            .keyword(.if), .number(0), .keyword(.then), .number(1), .keyword(.else), .number(2)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [
            .call("do", arguments: []),
            .number(0),
            .if(condition: .number(0), then: .number(1), else: .number(2))
        ]
        XCTAssert(program.onlyContains(expressions: expected))
    }

    func testComplexExpression() throws {
        let tokens: [Token] = [
                .symbol(.leftParenthesis),
                .keyword(.if),
                    .identifier("condition"),
                    .symbol(.leftParenthesis),
                        .identifier("p1"), .symbol(.comma),
                        .identifier("foo"), .symbol(.leftParenthesis), .symbol(.rightParenthesis),
                    .symbol(.rightParenthesis),
                .keyword(.then),
                    .keyword(.if), .number(0),
                    .keyword(.then), .identifier("v"),
                    .keyword(.else), .number(5),
                .keyword(.else),
                    .symbol(.leftParenthesis), .number(10), .symbol(.rightParenthesis),
                .symbol(.rightParenthesis),
            .operator(.minus),
                .number(5), .operator(.times), .identifier("last"), .operator(.divide), .number(1)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Expression] = [
            .binary(
                lhs:
                .if(
                    condition:
                    .call("condition", arguments: [.variable("p1"), .call("foo", arguments: [])]),
                    then:
                    .if(condition: .number(0), then: .variable("v"), else: .number(5)),
                    else:
                    .number(10)
                ),

                operator: .minus,

                rhs:
                .binary(
                    lhs: .number(5),
                    operator: .times,
                    rhs: .binary(lhs: .variable("last"), operator: .divide, rhs: .number(1))
                )
            )
        ]
        
        XCTAssertNoDifference(program, Program(expressions: expected))
    }

    func testExternalFunctionWithoutParameters() throws {
        let tokens: [Token] = [
            .keyword(.external), .identifier("printf"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Prototype] = [.init(name: "printf", parameters: [])]
        XCTAssert(program.onlyContains(externals: expected))
    }

    func testExternalFunctionWithParameters() throws {
        let tokens: [Token] = [
            .keyword(.external), .identifier("printf"), .symbol(.leftParenthesis),
            .identifier("p1"), .symbol(.comma),
            .identifier("p2"), .symbol(.comma),
            .identifier("p3"),
            .symbol(.rightParenthesis), .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Prototype] = [.init(name: "printf", parameters: ["p1", "p2", "p3"])]
        XCTAssert(program.onlyContains(externals: expected))
    }

    func testExternalFunctionMissingSemicolon() {
        let tokens: [Token] = [
            .keyword(.external), .identifier("printf"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, nil)
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testExternalFunctionMissingParameterList() {
        let tokens: [Token] = [
            .keyword(.external), .identifier("printf"), .symbol(.semicolon)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .symbol(.semicolon))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testMultipleExternalFunctions() throws {
        let tokens: [Token] = [
            .keyword(.external), .identifier("one"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .symbol(.semicolon),

            .keyword(.external), .identifier("one"), .symbol(.leftParenthesis),
            .identifier("p1"), .symbol(.comma),
            .identifier("p2"),
            .symbol(.rightParenthesis), .symbol(.semicolon),

            .keyword(.external), .identifier("three"), .symbol(.leftParenthesis),
            .identifier("en"), .symbol(.comma),
            .identifier("to"), .symbol(.comma),
            .identifier("tre"),
            .symbol(.rightParenthesis), .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Prototype] = [
            .init(name: "one", parameters: []),
            .init(name: "one", parameters: ["p1", "p2"]),
            .init(name: "three", parameters: ["en", "to", "tre"])
        ]
        XCTAssert(program.onlyContains(externals: expected))
    }

    func testFunctionDefinitionWithoutParameters() throws {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("number_5"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .number(5),
            .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Function] = [
            .init(head: .init(name: "number_5", parameters: []), body: .number(5))
        ]
        XCTAssert(program.onlyContains(functions: expected))
    }

    func testFunctionDefinitionWithParameters() throws {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("number_10"),
            .symbol(.leftParenthesis),
            .identifier("_1"), .symbol(.comma), .identifier("_1"),
            .symbol(.rightParenthesis),
            .number(10),
            .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Function] = [
            .init(head: .init(name: "number_10", parameters: ["_1", "_1"]), body: .number(10))
        ]
        XCTAssert(program.onlyContains(functions: expected))
    }

    func testFunctionDefinitionWithMultipleReturnExpressions() {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("ten_twenty"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .number(10),
            .number(20),
            .symbol(.semicolon)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .number(20))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testFunctionDefinitionMissingReturnExpression() {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("missing"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .symbol(.semicolon)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .symbol(.semicolon))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testFunctionDefinitionMissingSemicolon() {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("malformed"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .number(10)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, nil)
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testFunctionDefinitionMissingParameterList() {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("missing"),
            .number(10), .symbol(.semicolon)
        ]

        do {
            _ = try programParser.parse(tokens)
            XCTFail("Expected an error to be thrown.")
        } catch {
//            if let error = error as? Parser<LexerMock>.Error {
//                XCTAssertEqual(error.unexpectedToken, .number(10))
//            } else {
//                XCTFail("Expected a `Parser.Error` to be thrown.")
//            }
        }
    }

    func testMultipleFunctionDefinitions() throws {
        let tokens: [Token] = [
            .keyword(.definition), .identifier("first"),
            .symbol(.leftParenthesis), .symbol(.rightParenthesis),
            .number(10),
            .symbol(.semicolon),

            .keyword(.definition), .identifier("first"),
            .symbol(.leftParenthesis),
            .identifier("_1"), .symbol(.comma), .identifier("_2"),
            .symbol(.rightParenthesis),
            .number(100),
            .symbol(.semicolon),

            .keyword(.definition), .identifier("other"),
            .symbol(.leftParenthesis),
            .identifier("only"),
            .symbol(.rightParenthesis),
            .number(1),
            .symbol(.semicolon)
        ]
        let program = try programParser.parse(tokens)

        let expected: [Function] = [
            .init(head: .init(name: "first", parameters: []), body: .number(10)),
            .init(head: .init(name: "first", parameters: ["_1", "_2"]), body: .number(100)),
            .init(head: .init(name: "other", parameters: ["only"]), body: .number(1))
        ]
        XCTAssert(program.onlyContains(functions: expected))
    }
}

// MARK: - Testing Helpers

private extension Program {
    
    func onlyContains(externals: [Prototype]) -> Bool {
        functions.isEmpty && expressions.isEmpty && (self.externals == externals)
    }
    
    func onlyContains(functions: [Function]) -> Bool {
        externals.isEmpty && expressions.isEmpty && (self.functions == functions)
    }
    
    func onlyContains(expressions: [Expression]) -> Bool {
        externals.isEmpty && functions.isEmpty && (self.expressions == expressions)
    }
}
