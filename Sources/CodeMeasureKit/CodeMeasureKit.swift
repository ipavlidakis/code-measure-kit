//
//  CodeMeasureKit.swift
//  CodeMeasureKit
//

import Foundation
import Combine
import OSLog

/// A global flag that enables or disables performance measurement.
/// - Note: If `isEnabled` is `false`, all calls to `measureCallRate`
///   will be ignored.
nonisolated(unsafe) public var isEnabled = true

/// Measures the call rate of a given code block.
///
/// This function is designed to be used in methods or blocks of code
/// where you want to track how often they are called. The function stores
/// the call count based on the file, function, and line where it is
/// invoked.
///
/// - Parameters:
///   - fileName: The name of the file where the call is made. This
///     defaults to the current file using `#file`.
///   - functionName: The name of the function where the call is made.
///     This defaults to the current function using `#function`.
///   - line: The line number where the call is made. This defaults
///     to the current line using `#line`.
///
/// - Important: The measurement only occurs if `isEnabled` is `true`.
public func measureCallRate(
    fileName: StaticString = #file,
    functionName: StaticString = #function,
    line: UInt = #line
) {
    guard isEnabled else { return }
    MeasureCallRateStorage
        .shared
        .callRateMeter(fileName: fileName, functionName: functionName, line: line)
        .recordCall()
}

/// A logger instance used for logging performance-related information.
let logger = Logger(
    subsystem: "dev.ipavlidakis.code-measure-kit",
    category: "performance"
)

/// A singleton class responsible for managing call rate meters and
/// triggering updates.
///
/// This class maintains a dictionary of `CallRateMeter` objects, one for
/// each file/function/line combination. It also uses a timer to trigger
/// periodic updates of the call rate.
private final class MeasureCallRateStorage: @unchecked Sendable {
    /// The shared instance of `MeasureCallRateStorage` (singleton).
    static let `shared` = MeasureCallRateStorage()

    /// A thread-safe queue used for synchronizing access to the storage.
    private let queue = UnfairQueue()

    /// A Combine cancellable for handling the periodic timer events.
    private var cancellable: AnyCancellable?

    /// The storage dictionary that maps a unique string (file:function:line)
    /// to `CallRateMeter` instances.
    private var storage: [String: CallRateMeter] = [:]

    /// Initializes the `MeasureCallRateStorage` and starts a timer that
    /// triggers every second. On each timer tick, it updates the call rate
    /// for all stored meters.
    private init() {
        cancellable = Foundation
            .Timer
            .publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in self?.didTrigger() }
    }

    /// Triggered by the periodic timer to update all call rate meters.
    ///
    /// This method iterates over all stored meters and calls their
    /// `didUpdate()` method.
    private func didTrigger() {
        let meters = queue.sync { storage.values }
        meters.forEach { $0.didUpdate() }
    }

    /// Retrieves or creates a `CallRateMeter` for the specified file,
    /// function, and line.
    ///
    /// If a meter already exists for the given file/function/line
    /// combination, it is returned. Otherwise, a new `CallRateMeter` is
    /// created, stored, and returned.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file where the call is being measured.
    ///   - functionName: The name of the function where the call is
    ///     being measured.
    ///   - line: The line number where the call is being measured.
    /// - Returns: A `CallRateMeter` instance corresponding to the
    ///   file, function, and line.
    func callRateMeter(
        fileName: StaticString,
        functionName: StaticString,
        line: UInt
    ) -> CallRateMeter {
        let key = "\(fileName):\(functionName):\(line)"
        return queue.sync {
            if let meter = storage[key] {
                return meter
            } else {
                let meter = CallRateMeter(
                    fileName: fileName,
                    functionName: functionName,
                    line: line
                )
                storage[key] = meter
                return meter
            }
        }
    }
}

/// A class that tracks the call rate of a specific code block.
///
/// Each `CallRateMeter` tracks the number of times a specific code block
/// (identified by file, function, and line) is called over time, and
/// records both the maximum and minimum call counts within each update
/// cycle.
private final class CallRateMeter {
    /// The name of the file where this meter is measuring calls.
    private let fileName: StaticString

    /// The name of the function where this meter is measuring calls.
    private let functionName: StaticString

    /// The line number where this meter is measuring calls.
    private let line: UInt

    /// A thread-safe queue used for synchronizing access to call count data.
    private let queue = UnfairQueue()

    /// The current number of calls since the last update.
    private var callCount: Int = 0

    /// The maximum number of calls within an update cycle.
    private var maxCallCount: Int = 0

    /// The minimum number of calls within an update cycle.
    private var minCallCount: Int = 0

    /// Initializes a new `CallRateMeter` for a given file, function, and line.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file where calls are being tracked.
    ///   - functionName: The name of the function where calls are being
    ///     tracked.
    ///   - line: The line number where calls are being tracked.
    init(
        fileName: StaticString,
        functionName: StaticString,
        line: UInt
    ) {
        self.fileName = fileName
        self.functionName = functionName
        self.line = line
    }

    /// Updates the call rate statistics and resets the call count.
    ///
    /// This method is typically called on a timer (once per second) to
    /// update the maximum and minimum call counts and reset the current
    /// call count for the next period.
    func didUpdate() {
        queue.sync { [callCount, maxCallCount, minCallCount] in
            self.maxCallCount = max(callCount, maxCallCount)
            self.minCallCount = min(callCount, minCallCount)
            logger.debug("Call rate updated with count:\(callCount) max:\(maxCallCount) min:\(minCallCount).")
            self.callCount = 0
        }
    }

    /// Increments the function call count.
    ///
    /// Call this method inside the function you want to monitor to track
    /// how often that function is being invoked.
    func recordCall() {
        queue.sync { callCount += 1 }
    }
}
