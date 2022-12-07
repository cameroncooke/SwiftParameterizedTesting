//
//  ExampleExpectedValuesTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
@testable import ParameterizedTesting

final class ExampleExpectedValuesTests: ParameterizedTestCase2<WeatherData.Weather, Int, String> {
    // MARK: - Internal -

    override class func values() -> ([WeatherData.Weather], [Int]) {
        (
            [.raining, .sunny, .cloudy, .snowing],
            [12, 34, 3, 22, 0]
        )
    }

    override class func expectedValues() -> [String] {
        [
            "It's raining and a mild 12 degrees celsius",
            "It's raining and a hot 34 degrees celsius",
            "It's raining and a cold 3 degrees celsius",
            "It's raining and a comfortable 22 degrees celsius",
            "It's raining and a freezing 0 degrees celsius",

            "It's sunny and a mild 12 degrees celsius",
            "It's sunny and a hot 34 degrees celsius",
            "It's sunny and a cold 3 degrees celsius",
            "It's sunny and a comfortable 22 degrees celsius",
            "It's sunny and a freezing 0 degrees celsius",

            "It's cloudy and a mild 12 degrees celsius",
            "It's cloudy and a hot 34 degrees celsius",
            "It's cloudy and a cold 3 degrees celsius",
            "It's cloudy and a comfortable 22 degrees celsius",
            "It's cloudy and a freezing 0 degrees celsius",

            "It's snowing and a mild 12 degrees celsius",
            "It's snowing and a hot 34 degrees celsius",
            "It's snowing and a cold 3 degrees celsius",
            "It's snowing and a comfortable 22 degrees celsius",
            "It's snowing and a freezing 0 degrees celsius",
        ]
    }

    override func testAllCombinations(
        _ weather: WeatherData.Weather,
        _ temperature: Int,
        _ expectedResult: String? = nil
    ) {
        let sut = WeatherData(weather: weather, temperature: temperature)
        XCTAssertEqual(sut.summary, expectedResult)
    }
}

// MARK: Fakes

struct WeatherData {
    enum Weather: String, Hashable, CaseIterable {
        case raining
        case sunny
        case cloudy
        case snowing
    }

    let weather: Weather
    let temperature: Int

    var summary: String {
        "It's \(weather.rawValue) and a \(adjective) \(temperature) degrees celsius"
    }

    private var adjective: String {
        switch temperature {
        case ...2: return "freezing"
        case 3 ... 10: return "cold"
        case 11 ... 19: return "mild"
        case 20 ... 25: return "comfortable"
        case 25...: return "hot"
        default: return ""
        }
    }
}
