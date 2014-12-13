//  EventTest.swift
//
//  Copyright (c) 2014 Ivan Chelovekov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import XCTest
import SwiftEvent

class EventTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEvent0_On() {
        var expectation = expectationWithDescription("Event called")
        var event = Event()
        event.on() {
            expectation.fulfill()
        }
        event.emit()

        waitForExpectationsWithTimeout(0.1, handler:nil)
    }

    func testEvent0_Once() {
        var counter = 0
        var event = Event()
        event.on() {
            counter += 1
        }
        event.once() {
            counter += 2
        }
        event.emit() // 0 + 1 + 2 = 3
        event.emit() // 3 + 1 = 4
        event.emit() // 4 + 1 = 5

        XCTAssertEqual(counter, 5, "Event called once")
    }

    func testEvent1_On() {
        var expectation = expectationWithDescription("Event called")
        var event = EventWith<String>()
        event.on() { (state) in
            expectation.fulfill()
            XCTAssertEqual(state, "OK", "param correctly")
        }
        event.emitWith("OK")

        waitForExpectationsWithTimeout(0.1, handler:nil)
    }

    func testEvent1_Once() {
        var counter = 0
        var event = EventWith<Int>()
        event.once() {
            counter += $0
        }
        event.on() {
            counter += $0
        }
        event.emitWith(1) // 0 + 1 + 1 = 2
        event.emitWith(4) // 2 + 4 = 6
        event.emitWith(3) // 6 + 3 = 9

        XCTAssertEqual(counter, 9, "Event called once")
    }

    func testEvent2_On() {
        var expectation = expectationWithDescription("Event called")
        var event = EventDue<String, String>()
        event.on() { (s1, s2) in
            expectation.fulfill()
            XCTAssertEqual("\(s1) \(s2)", "Hello World", "param correctly")
        }
        event.emitWith("Hello", and: "World")

        waitForExpectationsWithTimeout(0.1, handler:nil)
    }

    func testEvent2_Once() {
        var counter1 = 0
        var counter2 = 0
        var event = EventDue<Int, Int>()
        event.once() {
            counter1 += $0
            counter2 += $1
        }
        event.on() {
            counter1 += $0
            counter2 += $1
        }

        event.emitWith(1, and: 5) // 0 + 1 + 1 = 2
        event.emitWith(4, and: 1) // 2 + 4 = 6
        event.emitWith(3, and: 4) // 6 + 3 = 9

        XCTAssertEqual(counter1, 9, "Event called once")
        XCTAssertEqual(counter2, 15, "Event called once")
    }
}
