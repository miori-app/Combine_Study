//: [Previous](@previous)

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case responseError(statusCode: Int)
}

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
//
struct APIModel {
    //https://www.googleapis.com/books/v1/volumes?q=
    // "http://itunes.apple.com/lookup?id=\(appID)"
    static let scheme = "http"
    static let host = "itunes.apple.com"
    static let path = "/lookup"
    
    func searchApp(query: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = APIModel.scheme
        components.host = APIModel.host
        components.path = APIModel.path
        components.queryItems = [
            URLQueryItem(name: "id", value: "\(query)")
        ]
        return components
    }
}
    
struct IdusInfo:Codable {
    let resultCount: Int
    let results: [IdusDetailInfo]
}
struct IdusDetailInfo: Codable {
    let sellerName: String
    let description: String
    let screenshotUrls: [String]
}

final class NetworkService {
    let session: URLSession
    let api = APIModel()
    //네트워크 서비스가 생성될때 session 받도록 생성
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func getURL(appID: Int) throws -> URL {
        guard let url = api.searchApp(query: appID).url else {
            throw NetworkError.invalidRequest
        }
        return url
    }
    
    func fetchInfo(appID: Int) -> AnyPublisher<IdusInfo, Error> {
        //872469884
        let url = URL(string: "http://itunes.apple.com/lookup?id=\(appID)")!

        //let url = try getURL(appID: appID)
        //dataTask Publisher
        let publisher = session
            .dataTaskPublisher(for: url)
        // 서버에서 받은 response 확인
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
        // 받은 data  디코딩 잘하기
            .decode(type: IdusInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher() //type 지우는 역할
        return publisher
    }
}

// -- network 담당하는 network service
// NetworkService 이용한 network작업

let networkService = NetworkService(configuration: .default)

// 퍼블리셔 구독
let subscription = networkService
    .fetchInfo(appID: 872469884) //퍼블리셔
    .receive(on: RunLoop.main)
    //.print()
    //.retry(3)
    .sink { completion in
        print("completion: \(completion)")
    } receiveValue: { info in
        print("Info :\(info)")
    }






//: [Next](@next)



