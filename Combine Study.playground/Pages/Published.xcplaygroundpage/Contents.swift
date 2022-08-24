//: [Previous](@previous)

import Foundation
import UIKit
import Combine


final class SomeViewModel {
    @Published var name: String = "miori"
    var age: Int = 26
}

final class Label {
    var text: String = ""
}

let label = Label()
let viewModel = SomeViewModel()
print("text: \(label.text)")

//퍼블리셔
viewModel.$name.assign(to: \.text, on: label)
print("text: \(label.text)")

viewModel.name = "miyeon"
viewModel.age = 40
print("text: \(label.text)")
//: [Next](@next)
