//
//  Processor.swift
//
//  Created by Nick Ignatenko on 2017-11-05.
//  Copyright © 2017 Nick Ignatenko. All rights reserved.
//
//  Articulates basic control over how commands are sent to the processor for execution - multiple threads can be utilized.
//  Multithreading, concurrency & background programming are all sides of the same coin. Mostly used to ensure an uninterrupted user experience.
//
//  *NOTE:
//  CANNOT update an app’s UI outside the main thread. User Interface operations, like showing a dialog or updating the text on a button can ONLY be performed on the 'main' thread!
//  Grand Central Dispatch (GCD) is a wrapper around creating threads & managing that code.
//  Since Swift 3, GCD is object-oriented. Previously you’d work with low-level C-style functions.

import Foundation

class Processor {
    // MARK: Init
    private init() {}
    
    // MARK: Singleton
    static let shared = Processor()
}

// MARK: - Actions (grand central dispatch)
extension Processor {
    func backgroundThread(_ block: @escaping (() -> ())) {
        DispatchQueue.global().async { block() }
    }
    
    func mainThread(_ block: @escaping (() -> ())) {
        DispatchQueue.main.async(execute: { block() })
    }
    
    /** A task is dispatched to an operation queue & is given a priority. */
    func execute(inBackground background: @escaping (() -> ()), main: @escaping (() -> ())) {
        // GCD: original low-level C-style function BEFORE Swift 3.
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            // Download file or perform expensive task in background thread
//            background()
//            dispatch_async(dispatch_get_main_queue()) {
//                // Update the UI in main thread
//                main()
//            }
//        }
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform an expensive task in the background thread
            background()
            DispatchQueue.main.async {
                // Update the UI in main thread
                main()
            }
        }
    }
    
    /** Create a concurrent queue & perform a task asynchronously. */
    func dispatchConcurrentAsynchQueue(_ block: @escaping (()->())) {
        // QoS attribute (Quality-of-Service): tells the dispatcher how important the task that’s dispatched is. Very similar to the 'priority' parameter. Highest to lowest priority: DispatchQoS.userInteractive, .userInitiated, .utility & .background. Can also use .default, after which QoS information is inferred from the context of your code.
        let asyncQueue = DispatchQueue.init(label: "asyncQueue", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
        asyncQueue.async {
            block()
        }
    }
    
    /** Delay code block execution for a specified amount of seconds on the 'background' thread. */
    func delay(seconds: TimeInterval, backgroundThread block: @escaping (()->())) {
        let delay = DispatchTime.now() + .milliseconds(Int(1000*seconds))
        DispatchQueue.global().asyncAfter(deadline: delay) {
            block()
        }
    }
    
    /** Delay code block execution for a specified amount of seconds on the 'main' thread. */
    func delay(seconds: TimeInterval, mainThread block: @escaping (()->())) {
        let delay = DispatchTime.now() + .milliseconds(Int(1000*seconds))
        DispatchQueue.main.asyncAfter(deadline: delay) {
            block()
        }
    }
}

// MARK: - Actions (debug)
extension Processor {
    // *NOTE: Read this on threading https://medium.com/better-programming/threading-in-swift-simply-explained-5c8dd680b9b2
    
    /// Call to find out what the current thread is, at any given spot in your code.
    func doWork() {
        if Thread.current.isMainThread {
            print("\(#function) is on main thread")
        } else {
            // Example print: "Current thread in doWork() is <NSThread: 0x283...>{number = 3, name = (null)}"
            print("Current thread in \(#function) is \(Thread.current)")
        }
    }
    
    /// Measure the time it takes to execute code inside of the block.
    func measureTime(block: () -> ()) -> Double {
        let start = Date()
        block()
        let end = Date()
        return end.timeIntervalSince(start)
    }
    
    /// Measure the time it takes to execute code inside of the block.
    func measureTime(block: ()->Void, result: (_ seconds: TimeInterval)->Void) {
        let start = Date()
        block()
        let end = Date()
        let seconds = end.timeIntervalSince(start)
        result(seconds)
    }
}
