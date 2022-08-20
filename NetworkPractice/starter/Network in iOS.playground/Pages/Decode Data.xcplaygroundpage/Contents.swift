//: [Previous](@previous)

import Foundation


//struct GithubProfile: Codable {
//    let login: String
//    let avatarUrl: String
//    let htmlUrl: String
//    let followers: Int
//    let following: Int
//
//    enum CodingKeys: String, CodingKey {
//        case login
//        case avatarUrl = "avatar_url"
//        case htmlUrl = "html_url"
//        case followers
//        case following
//    }
//}

// App Model -> Json : Encoding
// Json -> App Model : Decoding ### 요거 필요
struct IdusInfo:Codable {
    let resultCount: Int
    let results: [IdusDetailInfo]
}
struct IdusDetailInfo: Codable {
    let sellerName: String
    let description: String
    let screenshotUrls: [String]
}

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

let url = URL(string: "http://itunes.apple.com/lookup?id=872469884")!

let task = session.dataTask(with: url) { data, response, err in
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
        print("--> 잘못된 response \(response)")
        return
    }
    
    guard let data = data else { return }
    //data -> 우리가 만든 모델
    do {
        let decoder = JSONDecoder()
        //응 IdusInfo 형태로 디코딩 할거야 from : data 를
        //실패할수 있으므로 try
        let idus = try decoder.decode(IdusInfo.self, from: data)
        print("decoding완 :\(idus.results)")
    } catch let error as NSError {
        print("error: \(error)")
    }
    
    //let result = String(data: data, encoding: .utf8)
    //print(result.)
}

task.resume()






//: [Next](@next)
