# ParameterizedTesting

![Run Tests](https://github.com/cameroncooke/SwiftParameterizedTesting/workflows/Swift/badge.svg)
[![License](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![codecov](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting/branch/main/graph/badge.svg?token=MPBFPN7OLI)](https://codecov.io/gh/cameroncooke/SwiftParameterizedTesting)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcameroncooke%2FSwiftParameterizedTesting%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/cameroncooke/SwiftParameterizedTesting)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcameroncooke%2FSwiftParameterizedTesting%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/cameroncooke/SwiftParameterizedTesting)

ParameterizedTesting allows you to easily create and run dynamic, run-time tests that test every combination of values from a given dataset. With this library, you can quickly and easily verify the behavior of your code with a wide range of input values, ensuring that your code is correct and robust. 

## Contents

  - [Installation](#installation)
    - [Xcode](#xcode)
    - [SwiftPM](#swiftpm)
  - [Demo](#demo)
  - [What are parameterized tests?](#what-are-parameterized-tests)
  - [Won't I just end up with a single test failing in Xcode if any of the permutations fail?](#wont-i-just-end-up-with-a-single-test-failing-in-xcode-if-any-of-the-permutations-fail)
  - [What use cases would suite parameterized testing?](#what-use-cases-would-suite-parameterized-testing)
  - [Any warnings?](#any-warnings)
  - [Example usage](#example-usage)
    - [Snapshot testing](#snapshot-testing)
    - [Logic testing](#logic-testing)
    - [Custom test names](#custom-test-names)
  - [Credits](#credits)
  - [License](#license)

## Installation

### Xcode

If using Xcode, add `https://github.com/cameroncooke/SwiftParameterizedTesting.git` to `Package Dependencies` list in your project's settings.

### SwiftPM

If you want to use SwiftParameterizedTesting in a project that uses SwiftPM, add the package as a dependency in Package.swift:


```swift
dependencies: [
    .package(url: "https://github.com/cameroncooke/SwiftParameterizedTesting.git", from: "0.1.3")
]
```

Next, add ParameterizedTesting as a dependency of your test target:

```swift
targets: [
  .target(name: "MyLibrary"),
  .testTarget(
    name: "MyLibraryTests",
    dependencies: [
      "MyLibrary",
      .product(name: "ParameterizedTesting", package: "SwiftParameterizedTesting"),
    ]
  )
]
```

## Demo

![Demo](https://user-images.githubusercontent.com/630601/206025630-2d8f96d3-66ae-4bb9-8185-540006700db5.gif)

## What are parameterized tests?

A parameterized test is a type of test in which the same test is run multiple times with different input values. This allows the tester to verify that the software behaves correctly for a wide range of input values, without having to manually create a separate test case for each individual value. This can help save time and effort by avoiding the need to write and maintain many individual test cases.

## Won't I just end up with a single test failing in Xcode if any of the permutations fail?

No, this is where the magic happens, `ParameterizedTesting` will dynamically create individual run-time tests for each combination of values so that you know exactly which tests have passed or failed. When you run the test suite, tests will appear in the Xcode test navigator for each combination of values.

## What use cases would suite parameterized testing?

This kind of test automation is especially helpful when snapshot testing where you want to ensure you have a snapshot representation for each configuration of a view where there are many permutations, but this can also be used for logic testing.

## Any warnings?

Please use this library carefully! It's very easy to end up with 1000s of run-time tests with just a few lines of code. Please be aware that the size of the test suite will grow exponentially for each additional set of values.

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

Above is a larger set of test values, 9 arrays of 4, 5, 2, 2, 2, 4, 2, 2, 2 values respectively. This test will generate `4 * 5 * 2 * 2 * 2 * 4 * 2 * 2 * 2 == 5120` tests!

It's important that you really consider the value of the tests you are creating when using parameterized tests and use them wisely. Even though you can test every combination doesn't mean you should and in general, you shouldn't.

## Example usage

### Snapshot testing

In your test target create a new Swift file and subclass one of the `ParameterizedTestCase` base classes. Say you want to create test permutations from two sets of data you would use the `ParameterizedTestCase2` base class as shown in the below example. You can use up to 9 datasets in total, just use the corresponding class name making note of the numeric suffix i.e. `ParameterizedTestCase9`.

```swift
final class MySnapshotTests: ParameterizedTestCase2<Weather, CelsiusTemperature, Void> {

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

The classes make use of generics, you must define the types of values for each set when defining the class. In the above example, the types of each dataset are defined as `<Weather, CelsiusTemperature, Void>`. The `Void` generic parameter is a placeholder for an expected value which is only needed when creating logic tests. For snapshot tests, it's not needed so here we set it to void.

Next just override the `testAllCombinations()` method, this will be autocompleted for you when using Xcode with the parameters already correctly typed. In your method just add the test logic that performs whichever test action you want using the injected values.

### Logic testing

Another valid use case is logic testing. When writing logic tests you'll probably want to check the injected values against expected values. 

```swift
final class MyLogicTests: ParameterizedTestCase2<Weather, CelsiusTemperature, String> {

    override class func values() -> ([WeatherData.Weather], [CelsiusTemperature]) {
        (
            [.raining, .sunny],
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
        ]
    }

    override func testAllCombinations(
        _ weather: Weather,
        _ temperature: CelsiusTemperature,
        _ expectedResult: String?
    ) {
        let sut = WeatherData(weather: weather, temperature: temperature)
        XCTAssertEqual(sut.summary, expectedResult)
    }
}
```

In the above example, unlike the snapshot testing example, we need to provide the third generic type that represents the type of expected value, instead of specifying `Void` we've specified `String`. 

In the `testAllCombinations()` method we can then execute the system under test (`sut`) providing the `WeatherData` model with the injected `Weather` and `CelsiusTemperature` values.  

We then assert that the generated "summary" String matches the expected result String. 

Fully worked examples can be found in [Tests/ExampleTests](Tests/ExampleTests)

### Custom test names

By default the name of each run-time test will be `test_` followed by an underscore delimited string representation for each value. If any of the values do not conform to [CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible) then the debug description will be used which will most likely be undesirable. In that case you can override the class method `class func testName(_:)` and create your own unique name for the given test values:

```swift
    override class func testName(_ value1: WeatherData.Weather, _ value2: Int) -> String {
        "weather_\(WeatherData.Weather)_and_\(value2)_degrees"
    }
}
```

Note that you don't need to provide the `test_` prefix as this will be appended to whatever value is returned from `class func testName(_:)`.

## Credits

This library is in part derived from https://github.com/approvals/ApprovalTests.Swift

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
