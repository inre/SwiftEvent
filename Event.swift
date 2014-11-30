//  Event.swift
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

import Foundation

public struct Listener {
    public typealias F = () -> Void
    let callback: F
    let once: Bool
}

public struct Event {
    private(set) var listeners = [Listener]()

    public init() {}

    public mutating func on(callback: Listener.F) {
        listeners.append(Listener(callback: callback, once: false))
    }

    public mutating func once(callback: Listener.F) {
        listeners.append(Listener(callback: callback, once: true))
    }

    public mutating func emit() {
        self.listeners = listeners.filter { (listener) in
            listener.callback()
            return !listener.once
        }
    }
}

public struct ListenerWith<P1> {
    public typealias F = (P1) -> Void
    let callback: F
    let once: Bool
}

public struct EventWith<P1> {
    private(set) var listeners = [ListenerWith<P1>]()

    public init() {}

    public mutating func on(callback: ListenerWith<P1>.F) {
        listeners.append(ListenerWith(callback: callback, once: false))
    }

    public mutating func once(callback: ListenerWith<P1>.F) {
        listeners.append(ListenerWith(callback: callback, once: true))
    }

    public mutating func emitWith(p1: P1) {
        self.listeners = listeners.filter { (listener) in
            listener.callback(p1)
            return !listener.once
        }
    }
}

public struct ListenerDue<P1, P2> {
    public typealias F = (P1, P2) -> Void
    let callback: F
    let once: Bool
}

public struct EventDue<P1, P2> {
    private(set) var listeners = [ListenerDue<P1, P2>]()

    public init() {}

    public mutating func on(callback: ListenerDue<P1, P2>.F) {
        listeners.append(ListenerDue(callback: callback, once: false))
    }

    public mutating func once(callback: ListenerDue<P1, P2>.F) {
        listeners.append(ListenerDue(callback: callback, once: true))
    }

    public mutating func emitWith(p1: P1, and p2: P2) {
        self.listeners = listeners.filter { (listener) in
            listener.callback(p1, p2)
            return !listener.once
        }
    }
}
