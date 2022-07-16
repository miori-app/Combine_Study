import Foundation
import Combine

// PassthroughSubject

// output, error type 설정
let relay = PassthroughSubject<String, Never>()
let subscription1 = relay.sink { value in
    print("subscription1 received value : \(value)")
}
relay.send("Hi 👋")
relay.send("Bye 👋")


// CurrentValueSubject





