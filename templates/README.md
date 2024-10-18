# Code Measure Kit

`Code Measure Kit` is a Swift package that provides an easy way to measure the execution rate of code blocks or functions. It is particularly useful for performance monitoring and tracking how frequently specific parts of your code are executed over time.

## Features

- Track the call rate of functions and code blocks.
- Aggregate metrics, including minimum, maximum, and total call counts.
- Thread-safe.
- Lightweight, with support for periodic updates.
- Simple integration with existing Swift code.

## Installation

Add `Code Measure Kit` to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/ipavlidakis/code-measure-kit.git", from: "VERSION_PLACEHOLDER")
]
```

## Usage

To start measuring the call rate of a function or block of code, you can use the measureCallRate function. Here’s how you can integrate it into your code:

### Example: Measuring a Function Call Rate

```swift
import CodeMeasureKit

func someFunction() {
    measureCallRate()
    // Function logic here
}
```

In the example above, measureCallRate() will track how often someFunction() is called and automatically log the results every second.

### Example: Measuring a Call Rate with Custom File, Function, and Line Information

```swift
import CodeMeasureKit

func anotherFunction() {
    measureCallRate(fileName: "CustomFile.swift", functionName: "customFunction", line: 42)
    // Function logic here
}
```

You can manually provide custom file, function, and line information if required. This is useful when you need more control over how call rates are tracked.

### Enable/Disable Call Rate Measurement

The measurement can be enabled or disabled globally using the isEnabled flag:

```swift
isEnabled = false  // Disables the call rate measurement
isEnabled = true   // Enables the call rate measurement
```

## License

This package is available under the MIT License. See the [LICENSE](LICENSE) file for more details.
