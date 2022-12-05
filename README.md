# ParameterizedTesting

![Run Tests](https://github.com/cameroncooke/SwiftParameterizedTesting/workflows/Swift/badge.svg)
[![License](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![codecov](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting/branch/main/graph/badge.svg?token=MPBFPN7OLI)](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcameroncooke%2FSwiftParameterizedTesting%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/cameroncooke/SwiftParameterizedTesting)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcameroncooke%2FSwiftParameterizedTesting%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/cameroncooke/SwiftParameterizedTesting)

ParameterizedTesting is a Swift library for executing parameterized tests using XCTest.

## Installation

If using SwiftPM add `.package(url: "https://github.com/cameroncooke/SwiftParameterizedTesting.git", from: "0.1.2")` to your `Package.swift` file as shown in the example below:


```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    products: [
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/cameroncooke/SwiftParameterizedTesting.git", from: "0.1.2")
    ],
    targets: [
        .target(
            name: "MyLibrary",
        ),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: [
                "MyLibrary",
                .product(name: "ParameterizedTesting", package: "SwiftParameterizedTesting"),
            ]
        ),
    ]
)

```

If using Xcode, add `https://github.com/cameroncooke/SwiftParameterizedTesting.git` to `Package Dependencies` in project settings.


## What are Parameterized tests?

A parameterized test is a test that runs over and over again using different values.

## Are there specific use-cases in mind?

Yes, this kind of test automation is especially helpful when snapshot testing where you want to ensure you have a snapshot representation for each configuration of a view where there are many permutations, but this can also be used for logic testing.

## Won't I just end up with a single test failing in Xcode if any of the permutations fail?

No, this is where the magic happens, `ParameterizedTesting` will dynamically create individual run-time tests for each permutation so that you know exactly which combination of values failed. When you run the test suite tests will appear in the Xcode test navigator for each combination of values.

## Any warnings?

Yes, please use this library carefully! It's very easy to end up with 1000s of run-time tests with just a few lines of code. Please be aware that the size of the test suite will grow exponentially for each additional set of values.

```swift
    override class func values() -> ([WeatherData.Weather], [CelsiusTemperature]) {
        (
            [.raining, .sunny, .cloudy, .snowing],
            [12, 34, 3, 22, 0]
        )
    }
```

Above is a simple set of test values, two arrays of 4 and 5 values respectfully. This test alone will generate `4 * 5 == 20` tests. 

Now let's look at a larger test dataset:

```swift
    override class func values() -> (
        [String],
        [CelsiusTemperature],
        [String],
        [String],
        [Double],
        [String],
        [String],
        [String],
        [Bool]
    ) {
        (
            [
                "raining",
                "sunny",
                "cloudy",
                "snowing",
            ],
            [
                12,
                34,
                3,
                22,
                0,
            ],
            [
                "apples",
                "oranges",
            ],
            [
                "red",
                "blue",
            ],
            [
                12.99,
                18.50,
            ],
            [
                "GB",
                "EU",
                "FR",
                "US",
            ],
            [
                "large",
                "small",
            ],
            [
                "red",
                "blue",
            ],
            [
                true,
                false,
            ]
        )
    }
```

Above is a larger set of test values, 9 arrays of 4, 5, 2, 2, 2, 4, 2, 2, 2 values respectfully. This test will generate `4 * 5 * 2 * 2 * 2 * 4 * 2 * 2 * 2 == 5120` tests!

It's important that you really consider the value of the tests you are creating when using parameterized tests and use wisely. Even though you can test every combination doesn't mean you should and in general you shouldn't.

## Example usage

In your test target create a new Swift file and subclass one of the `ParameterizedTestCase` base classes. Say you want to create test permutations from two sets of data you would use the `ParameterizedTestCase2` base class as shown in the below example. You can use up to 9 datasets in total, just use corresponding class name making note of the numeric suffix i.e. `ParameterizedTestCase9`.

```swift
final class MySnapshotTests: ParameterizedTestCase2<Weather, CelsiusTemperature, Void> {
    override class var defaultTestSuite: XCTestSuite {
        customTestSuite(self)
    }

    // MARK: - Internal -

    override class func values() -> ([Weather], [CelsiusTemperature]) {
        (
            [.raining, .sunny, .cloudy, .snowing],
            [12, 34, 3, 22, 0]
        )
    }

    override func testAllCombinations(
        _ weather: Weather,
        _ temperature: CelsiusTemperature,
        _ expectedResult: Void?
    ) {
        let view = WeatherView(
            viewModel: WeatherView.ViewModel(
                weather: weather,
                temperature: temperature,
            )
        )

        assertSnapshot(
            matching: view,
            testName: "\(weather)_\(temperature)"
        )
    }
}
```

The classes make use of generics, you must define the types of values for each set when defining the class. In the above example the types of each dataset are defined as `<Weather, CelsiusTemperature, Void>`. The `Void` generic pamemter is a placeholder for an expected value which is only needed when creating logic tests. For snapshot tests it's not needed so here we set it to void.

It's important that you override `defaultTestSuite` by pasting in the following code:

```swift
    override class var defaultTestSuite: XCTestSuite {
        customTestSuite(self)
    }
```

This is needed to workaround an issue when creating the run-time tests.

Next just override the `testAllCombinations()` method, this will be autocompleted for you when using Xcode with the parameters already correctly typed. In your method just add the test logic that performs whichever test action you want using the injected values.


More fully worked examples including logic tests can be found in [Tests/ExampleTests](Tests/ExampleTests)

## Credits

This library is in part derived from https://github.com/approvals/ApprovalTests.Swift

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
