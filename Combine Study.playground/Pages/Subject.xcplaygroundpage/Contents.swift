import Foundation
import Combine

// PassthroughSubject

// output, error type ์ค์ 
let relay = PassthroughSubject<String, Never>()
let subscription1 = relay.sink { value in
    print("subscription1 received value : \(value)")
}
relay.send("Hi ๐")
relay.send("Bye ๐")


// CurrentValueSubject
// ๊ธฐ์กด์ value ๋ณด๋ด๊ณ  ์์
let variable = CurrentValueSubject<String, Never>("")

// subscription ํ๊ธฐ ์ง์ ์ ๋ฐ์ดํฐ
variable.send("initial text")
let subscription2 = variable.sink { value in
    print("subscription2 received value : \(value)")
}

variable.send("This is Combine")
variable.send("์๋ ๋ฐ์ดํฐ ๋ณด๋ด์ฃผ๋ CurrentValueSubject")
variable.value //์๋ ๋ฐ์ดํฐ ๋ณด๋ด์ฃผ๋ CurrentValueSubject (๋ค๊ณ  ์๋ ๊ฐ ํ์ธ ๊ฐ๋ฅ)

// publisher๊ฐ ๋ฐฐ์ถํ ๋ฐ์ดํฐ๋ฅผ relay / variable ๊ฐ ๋ฐ์
let publisher = ["Snatch", "Clean", "Jerk"].publisher
publisher.subscribe(relay)
publisher.subscribe(variable)
