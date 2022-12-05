# ParameterizedTesting

![Run Tests](https://github.com/cameroncooke/SwiftParameterizedTesting/workflows/Swift/badge.svg)
[![License](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![codecov](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting/branch/main/graph/badge.svg?token=MPBFPN7OLI)](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting)

ParameterizedTesting is a Swift library for executing parameterized tests using XCTest for iOS.

## What are Parameterized tests?

A parameterized test is a test that runs over and over again using different values.

## Are there specific use-cases in mind?

Yes, this kind of test automation is especially helpful when snapshot testing where you want to ensure you have a snapshot representation for each configuration of a view where they are many permutations, but this can also be used for logic testing.

## Won't I just end up with a single test failing in Xcode if any of the permutations fail?

No, this is where the magic happens, `ParameterizedTesting` will dynamically create individual run-time tests for each permutation so that you know exactly which combination of values failed. When you run the test suite the each test will appear in the Xcode test navigator.

## Any warnings?

Yes, please use this library carefully! It's very easy to end up with 1000s of run-time tests with just a few lines of code. Please be aware that the size of the test suite will grow exponentially for each additional set of values.

```swift
    override class func values() -> ([WeatherData.Weather], [Int]) {
        (
            [.raining, .sunny, .cloudy, .snowing],
            [12, 34, 3, 22, 0]
        )
    }
```

Above is a simple set of test values, two arrays of 4 and 5 values respectfully. This test alone will generate `4 * 5 = 20` tests. 

Now let's look at a larger test dataset:

```swift
    override class func values() -> (
        [String],
        [Int],
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

Above is a larger set of test values, 9 arrays of 4, 5, 2, 2, 2, 4, 2, 2, 2 values respectfully. This test will generate `4 * 5 * 2 * 2 * 2 * 4 * 2 * 2 * 2 = 5120` tests!

It's important that you really consider the value of the parameterized tests and use wisely. Even though can test every combination doesn't mean you should and in general you shouldn't.

## Example usage

To use, in your test target create a new Swift file and subclass one of the `ParameterizedTestCase` base classes. Say you want to create test permutations from two sets of data you would use the `ParameterizedTestCase2` base class as shown in the below example, you can use up to 9 datasets in total. Just use corresponding class name i.e. `ParameterizedTestCase9`

```swift
final class MySnapshotTests: ParameterizedTestCase2<Weather, CelsiusTemperature, Void> {
    override class var defaultTestSuite: XCTestSuite {
        customTestSuite(self)
    }

    // MARK: - Internal -

    override class func values() -> ([Weather], [Int]) {
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

These classes use generics which you must define the types of when defining the class. In the above example the types of each dataset are defined as `<Weather, CelsiusTemperature, Void>`. The Void generic pamemter is a placeholder for an expected value which is only needed when creating logic tests. For snapshot tests it's not needed so here we seet this to void.

It's important that you override `defaultTestSuite` and paste in the following code:

```swift
    override class var defaultTestSuite: XCTestSuite {
        customTestSuite(self)
    }
```

This is needed to workaround an issue when creating the run-time tests.

Next just override the `testAllCombinations()` method, this will be autocompleted for you if using Xcode with the parameters already correctly typed. In your method just add the test logic that performs whichever test action you want with the injected values.


More fully worked examples including logic tests can be found in [Tests/ExampleTests](Tests/ExampleTests)

## Credits

This library is in part derived from https://github.com/approvals/ApprovalTests.Swift

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
