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
// 기존의 value 보내고 시작
let variable = CurrentValueSubject<String, Never>("")

// subscription 하기 직전의 데이터
variable.send("initial text")
let subscription2 = variable.sink { value in
    print("subscription2 received value : \(value)")
}

variable.send("This is Combine")
variable.send("있던 데이터 보내주는 CurrentValueSubject")
variable.value //있던 데이터 보내주는 CurrentValueSubject (들고 있는 값 확인 가능)

// publisher가 배출한 데이터를 relay / variable 가 받아
let publisher = ["Snatch", "Clean", "Jerk"].publisher
publisher.subscribe(relay)
publisher.subscribe(variable)
