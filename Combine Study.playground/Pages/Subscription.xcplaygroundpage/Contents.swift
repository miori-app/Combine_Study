//: [Previous](@previous)

import Foundation
import Combine


let subject = PassthroughSubject<String, Never>()


// The print() operator prints you all lifecycle events
let subscription = subject.sink { value in
    print("Subscriber received value: \(value)")
}

subject.send("Hello")
subject.send("Hello again!")
subject.send("Hello final")

subject.send(completion: .finished)
subject.send("gogo ??")

//: [Next](@next)
