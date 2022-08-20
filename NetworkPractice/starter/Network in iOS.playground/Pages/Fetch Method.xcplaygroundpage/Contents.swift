//: [Previous](@previous)

import Foundation

enum NetworkError: Error {
  case invalidRequest
  case transportError(Error)
  case responseError(statusCode: Int)
  case noData
  case decodingError(Error)
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
    
    //네트워크 서비스가 생성될때 session 받도록 생성
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func fetchInfo(appID: Int, completion: @escaping (Result<IdusInfo, Error>) -> Void) {
        //872469884
        let url = URL(string: "http://itunes.apple.com/lookup?id=\(appID)")!

        let task = session.dataTask(with: url) { data, response, err in
            
            if let err = err {
                completion(.failure(NetworkError.transportError(err)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                  !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.responseError(statusCode: httpResponse.statusCode)))
                return
            }
        
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            //data -> 우리가 만든 모델
            do {
                let decoder = JSONDecoder()
                //응 IdusInfo 형태로 디코딩 할거야 from : data 를
                //실패할수 있으므로 try
                let idus = try decoder.decode(IdusInfo.self, from: data)
                completion(.success(idus))
                //print("decoding완 :\(idus.results)")
            } catch let error as NSError {
                //print("error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
            
            //let result = String(data: data, encoding: .utf8)
            //print(result.)
        }

        task.resume()
    }
}

// -- network 담당하는 network service
// NetworkService 이용한 network작업

let networkService = NetworkService(configuration: .default)
networkService.fetchInfo(appID: 872469884) { result in
    switch result {
    case .success(let idus):
        print("Idus: \(idus)")
    case .failure(let error):
        print("Error:\(error)")
    }
}





//: [Next](@next)
