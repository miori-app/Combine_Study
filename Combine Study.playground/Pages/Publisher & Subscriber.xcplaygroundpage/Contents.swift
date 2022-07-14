//: [Previous](@previous)

import Foundation
import Combine

// Publisher & Subscriber

// just 는 딱 한번만
let just = Just(1000)
let subscription1 = just.sink { value in
    print("received value: \(value)")
}

let arrPublisher = [1,3,5,7,9].publisher
let subscription2 = arrPublisher.sink { value in
    print("received value: \(value)")
}

class MyClass {
    var property: Int = 0 {
        didSet {
            print("Did set property to \(property)")
        }
    }
}

let object1 = MyClass()
let subscription3 = arrPublisher.assign(to: \.property, on: object1)
//object1.property = 3
print("final value : \(object1.property)")




//: [Next](@next)


