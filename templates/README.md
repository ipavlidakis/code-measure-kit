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

### Measuring Function Call Rate

To start measuring how often a function is called, you can use the `measureCallRate` function. Here's an example:

#### Example: Measuring a Function Call Rate

```swift
import CodeMeasureKit

func someFunction() {
    measureCallRate()
    // Function logic here
}
```

In the example above, `measureCallRate()` will track how often `someFunction()` is called and automatically log the results every second.

### Measuring Execution Time

You can also measure how long it takes for a block of code (synchronous or asynchronous) to execute using `measureExecutionTime`.

#### Example: Measuring Synchronous Execution Time

```swift
import CodeMeasureKit

func performSomeTask() {
    let result = measureExecutionTime {
        // Code whose execution time is being measured
        performComputation()
    }
    print("Result: \(result)")
}
```

In this example, the execution time of `performComputation()` will be measured, and the result will be printed once it completes. If `isEnabled` is `false`, the execution time will not be logged.

#### Example: Measuring Asynchronous Execution Time

```swift
import CodeMeasureKit

func performSomeAsyncTask() async {
    let result = await measureExecutionTime {
        // Asynchronous code whose execution time is being measured
        await performAsyncComputation()
    }
    print("Result: \(result)")
}
```

In this asynchronous example, the execution time of `performAsyncComputation()` will be measured. The result will be printed once the asynchronous task completes. If `isEnabled` is `false`, the execution time will not be logged.

### Enabling/Disabling Measurement

The measurement can be globally enabled or disabled using the `isEnabled` flag:

```swift
isEnabled = false  // Disable performance measurement
isEnabled = true   // Enable performance measurement
```

## License

This package is available under the MIT License. See the [LICENSE](LICENSE) file for more details.
