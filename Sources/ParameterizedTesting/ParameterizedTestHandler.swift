//
//  ParameterizedTestHandler.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

public enum ParameterizedTestHandler {
    private enum UNUSED {
        case unused
    }

    private static var unused: [UNUSED] { [.unused] }

    // MARK: - open -

    public static func allCombinations<IN1>(
        _ params1: [IN1],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1) -> Void
    ) {
        let handlerWithAllParameters: (IN1, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $1
            _ = $2
            _ = $3
            _ = $4
            _ = $5
            _ = $6
            _ = $7
            _ = $8
            handler($0)
        }

        allCombinations(
            params1,
            unused, unused, unused, unused, unused, unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2>(
        _ params1: [IN1],
        _ params2: [IN2],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $2
            _ = $3
            _ = $4
            _ = $5
            _ = $6
            _ = $7
            _ = $8
            handler($0, $1)
        }

        allCombinations(
            params1, params2,
            unused, unused, unused, unused, unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $3
            _ = $4
            _ = $5
            _ = $6
            _ = $7
            _ = $8
            handler($0, $1, $2)
        }

        allCombinations(
            params1, params2, params3,
            unused, unused, unused, unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3, IN4) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, IN4, UNUSED, UNUSED, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $4
            _ = $5
            _ = $6
            _ = $7
            _ = $8
            handler($0, $1, $2, $3)
        }

        allCombinations(
            params1, params2, params3, params4,
            unused, unused, unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4, IN5>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        _ params5: [IN5],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3, IN4, IN5) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, IN4, IN5, UNUSED, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $5
            _ = $6
            _ = $7
            _ = $8
            handler($0, $1, $2, $3, $4)
        }

        allCombinations(
            params1, params2, params3, params4, params5,
            unused, unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4, IN5, IN6>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        _ params5: [IN5],
        _ params6: [IN6],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3, IN4, IN5, IN6) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, IN4, IN5, IN6, UNUSED, UNUSED, UNUSED) -> Void = {
            _ = $6
            _ = $7
            _ = $8
            handler($0, $1, $2, $3, $4, $5)
        }

        allCombinations(
            params1, params2, params3, params4, params5, params6,
            unused, unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4, IN5, IN6, IN7>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        _ params5: [IN5],
        _ params6: [IN6],
        _ params7: [IN7],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, UNUSED, UNUSED) -> Void = {
            _ = $7
            _ = $8
            handler($0, $1, $2, $3, $4, $5, $6)
        }

        allCombinations(
            params1, params2, params3, params4, params5, params6, params7,
            unused, unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        _ params5: [IN5],
        _ params6: [IN6],
        _ params7: [IN7],
        _ params8: [IN8],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: @escaping (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8) -> Void
    ) {
        let handlerWithAllParameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, UNUSED) -> Void = {
            _ = $8
            handler($0, $1, $2, $3, $4, $5, $6, $7)
        }

        allCombinations(
            params1, params2, params3, params4, params5, params6, params7, params8,
            unused,
            file: file, line: line,
            handlerWithAllParameters
        )
    }

    public static func allCombinations<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9>(
        _ params1: [IN1],
        _ params2: [IN2],
        _ params3: [IN3],
        _ params4: [IN4],
        _ params5: [IN5],
        _ params6: [IN6],
        _ params7: [IN7],
        _ params8: [IN8],
        _ params9: [IN9],
        file: StaticString = #filePath,
        line: UInt = #line,
        _ handler: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9) -> Void
    ) {
        for in1 in params1 {
            for in2 in params2 {
                for in3 in params3 {
                    for in4 in params4 {
                        for in5 in params5 {
                            for in6 in params6 {
                                for in7 in params7 {
                                    for in8 in params8 {
                                        for in9 in params9 {
                                            handler(in1, in2, in3, in4, in5, in6, in7, in8, in9)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
