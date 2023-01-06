//
//  ExampleSnapshotTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import SnapshotTesting
import SwiftUI
import XCTest
@testable import ParameterizedTesting

final class ExampleSnapshotTests: ParameterizedTestCase3<Weather, Int, Theme, Void> {
    // MARK: - Internal -

    override class func values() -> ([Weather], [Int], [Theme]) {
        (
            [.raining, .sunny, .cloudy, .snowing],
            [12, 34, 3, 22, 0],
            [.light, .dark]
        )
    }

    override func testAllCombinations(
        _ weather: Weather,
        _ temperature: Int,
        _ theme: Theme,
        _ expectedResult: Void?
    ) {
        let view = WeatherView(
            viewModel: WeatherView.ViewModel(
                weather: weather,
                temperature: temperature,
                theme: theme
            )
        )

#if os(iOS) || os(tvOS)
        // Recorded on iPhone 14 (iOS 16.x)
        assertSnapshot(
            matching: view,
            as: .image(
                precision: 0.9,
                perceptualPrecision: 0.98,
                layout: .fixed(width: 400, height: 45)
            ),
            testName: "\(weather)_\(temperature)_\(theme)_iOS"
        )
#else
        let viewController = NSHostingController(rootView: view)
        
        XCTExpectFailure("Might fail as reference images were created on different OS environment")

        assertSnapshot(
            matching: viewController,
            as: .image(
                precision: 0.9,
                perceptualPrecision: 0.98,
                size: CGSize(width: 400, height: 45)
            ),
            testName: "\(weather)_\(temperature)_\(theme)_macOS"
        )
#endif
    }
}

// MARK: Fakes

typealias Weather = WeatherView.ViewModel.Weather
typealias Theme = WeatherView.ViewModel.Theme

struct WeatherView: View {
    struct ViewModel {
        enum Weather: String, Hashable, CaseIterable {
            case raining
            case sunny
            case cloudy
            case snowing
        }

        enum Theme: Hashable, CaseIterable {
            case light
            case dark
        }

        let weather: Weather
        let temperature: Int
        let theme: Theme

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

        var weatherEmoji: String {
            switch weather {
            case .raining: return "🌧️"
            case .sunny: return "☀️"
            case .cloudy: return "☁️"
            case .snowing: return "🌨️"
            }
        }
    }

    let viewModel: ViewModel

    var body: some View {
        VStack {
            Text(viewModel.weatherEmoji)
                .font(.headline)
            Spacer(minLength: 4)
            Text(viewModel.summary)
                .foregroundColor(viewModel.theme == Theme.light ? Color.black : Color.white)
                .background(viewModel.theme == Theme.light ? Color.gray : Color.black)
        }
    }
}
