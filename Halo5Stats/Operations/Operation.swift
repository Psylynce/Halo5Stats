/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains the foundational subclass of NSOperation.
*/

import Foundation

/**
    The subclass of `NSOperation` from which all other operations should be derived.
    This class adds both Conditions and Observers, which allow the operation to define
    extended readiness requirements, as well as notify many interested parties
    about interesting operation state changes
*/
open class Operation: Foundation.Operation {

    // MARK: State Management

    fileprivate enum State: Int, Comparable {
        /// The initial state of an `Operation`.
        case initialized

        /// The `Operation` is ready to begin evaluating conditions.
        case pending

        /// The `Operation` is evaluating conditions.
        case evaluatingConditions

        /**
            The `Operation`'s conditions have all been satisfied, and it is ready
            to execute.
        */
        case ready

        /// The `Operation` is executing.
        case executing

        /**
            Execution of the `Operation` has finished, but it has not yet notified
            the queue of this.
        */
        case finishing

        /// The `Operation` has finished executing.
        case finished

        /// The `Operation` has been cancelled.
        case cancelled

        func canTransitionToState(_ target: State) -> Bool {
            switch (self, target) {
            case (.initialized, .pending):
                return true
            case (.pending, .evaluatingConditions):
                return true
            case (.pending, .finishing):
                return true
            case (.evaluatingConditions, .ready):
                return true
            case (.ready, .executing):
                return true
            case (.ready, .finishing):
                return true
            case (.executing, .finishing):
                return true
            case (.finishing, .finished):
                return true
            default:
                return false
            }
        }
    }

    override open class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        var set = super.keyPathsForValuesAffectingValue(forKey: key)

        if key == "isReady" || key == "isExecuting" || key == "isFinished" || key == "isCancelled" {
            set.insert("state")
        }

        return set
    }

    /**
        Indicates that the Operation can now begin to evaluate readiness conditions,
        if appropriate.
    */
    func willEnqueue() {
        state = .pending
    }

    /// Private storage for the `state` property that will be KVO observed.
    fileprivate var _state = State.initialized

    /// A lock to guard reads and writes to the `_state` property
    fileprivate var stateLock = NSRecursiveLock()

    fileprivate var state: State {
        get {
            return stateLock.withCriticalScope {
                _state
            }
        }

        set(newState) {
            // Manually fire the KVO notifications for state change, since this is "private".
            stateLock.withCriticalScope {
                willChangeValue(forKey: "state")

                assert(_state.canTransitionToState(newState), "Invalid state transition")

                if _state != .finished {
                    _state = newState
                }

                didChangeValue(forKey: "state")
            }
        }
    }

    // Here is where we extend our definition of "readiness".
    override open var isReady: Bool {
        var result = false

        stateLock.withCriticalScope { () -> Void in
            switch state {
            case .initialized:
                result = isCancelled

            case .pending:
                guard !isCancelled else {
                    result = true
                    return
                }

                if super.isReady {
                    evaluateConditions()
                }

                result = false

            case .ready:
                result = super.isReady || isCancelled

            default:
                result = false
            }
        }

        return result
    }

    open var userInitiated: Bool {
        get {
            return qualityOfService == .userInitiated
        }

        set {
            assert(state < .executing, "Cannot modify userInitiated after execution has begun.")

            qualityOfService = newValue ? .userInitiated : .default
        }
    }

    fileprivate(set) open var failed = false

    override open var isExecuting: Bool {
        return state == .executing
    }

    override open var isFinished: Bool {
        return state == .finished
    }

    override open var isCancelled: Bool {
        return state == .cancelled
    }

    fileprivate func evaluateConditions() {
        assert(state == .pending, "evaluateConditions() was called out-of-order")

        state = .evaluatingConditions

        OperationConditionEvaluator.evaluate(conditions, operation: self) { failures in
            self._internalErrors.append(contentsOf: failures)
            self.state = .ready
        }
    }

    // MARK: Observers and Conditions

    fileprivate(set) var conditions = [OperationCondition]()

    open func addCondition(_ condition: OperationCondition) {
        assert(state < .evaluatingConditions, "Cannot modify conditions after execution has begun.")

        conditions.append(condition)
    }

    fileprivate(set) var observers = [OperationObserver]()

    open func addObserver(_ observer: OperationObserver) {
        assert(state < .executing, "Cannot modify observers after execution has begun.")

        observers.append(observer)
    }

    override open func addDependency(_ operation: Foundation.Operation) {
        assert(state <= .executing, "Dependencies cannot be modified after execution has begun.")

        super.addDependency(operation)
    }

    // MARK: Execution and Cancellation

    override final public func start() {
        super.start()

        if name == nil {
            name = String(describing: self)
        }

        if isCancelled {
            finish()
        }
    }

    override final public func main() {
        assert(state == .ready, "This operation must be performed on an operation queue.")

        if _internalErrors.isEmpty && !isCancelled {
            state = .executing

            for observer in observers {
                observer.operationDidStart(self)
            }

            execute()
        } else {
            finish()
        }
    }

    /**
        `execute()` is the entry point of execution for all `Operation` subclasses.
        If you subclass `Operation` and wish to customize its execution, you would
        do so by overriding the `execute()` method.

        At some point, your `Operation` subclass must call one of the "finish"
        methods defined below; this is how you indicate that your operation has
        finished its execution, and that operations dependent on yours can re-evaluate
        their readiness state.
    */
    open func execute() {
        print("\(type(of: self)) must override `execute()`.")

        finish()
    }

    fileprivate var _internalErrors = [Error]()

    open func cancelWithError(_ error: Error? = nil) {
        if let error = error {
            _internalErrors.append(error)
        }

        cancel()
    }

    final func produceOperation(_ operation: Foundation.Operation) {
        for observer in observers {
            observer.operation(self, didProduceOperation: operation)
        }
    }

    // MARK: Finishing

    /**
        Most operations may finish with a single error, if they have one at all.
        This is a convenience method to simplify calling the actual `finish()`
        method. This is also useful if you wish to finish with an error provided
        by the system frameworks. As an example, see `DownloadEarthquakesOperation`
        for how an error from an `NSURLSession` is passed along via the
        `finishWithError()` method.
    */
    final public func finishWithError(_ error: Error?) {
        if let error = error {
            finish([error])
        } else {
            finish()
        }
    }

    /**
        A private property to ensure we only notify the observers once that the
        operation has finished.
    */
    fileprivate var hasFinishedAlready = false
    final public func finish(_ errors: [Error] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .finishing

            let combinedErrors = _internalErrors + errors
            failed = !combinedErrors.isEmpty

            finished(combinedErrors)

            for observer in observers {
                observer.operationDidFinish(self, errors: combinedErrors)
            }

            state = .finished
        }
    }

    /**
        Subclasses may override `finished(_:)` if they wish to react to the operation
        finishing with errors. For example, the `LoadModelOperation` implements
        this method to potentially inform the user about an error when trying to
        bring up the Core Data stack.
    */
    open func finished(_ errors: [Error]) {
        // No op.
    }

    override open func waitUntilFinished() {
        /*
            Waiting on operations is almost NEVER the right thing to do. It is
            usually superior to use proper locking constructs, such as `dispatch_semaphore_t`
            or `dispatch_group_notify`, or even `NSLocking` objects. Many developers
            use waiting when they should instead be chaining discrete operations
            together using dependencies.

            To reinforce this idea, invoking `waitUntilFinished()` will crash your
            app, as incentive for you to find a more appropriate way to express
            the behavior you're wishing to create.
        */
        fatalError("Waiting on operations is an anti-pattern. Remove this ONLY if you're absolutely sure there is No Other Way™.")
    }

}

// Simple operator functions to simplify the assertions used above.
private func < (lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

private func == (lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
