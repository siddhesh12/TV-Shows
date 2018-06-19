//
//  NetworkManager.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 17/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Result<T> {
  case success(T)
  case failure(String)
}

enum NetworkResult<String>{
  case success
  case failure(String)
}

enum NetworkEnvironment {
  case qa
  case production
  case staging
}

enum NetworkResponse:String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

final class NetworkManager {
  static let configuration = URLSessionConfiguration.default
  static let environment : NetworkEnvironment = .production
  
  fileprivate func buildRequest(from route: EndPointType) -> URLRequest {
    return URLRequest(url: URL(string: route.baseURL+route.path)!,
                      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                      timeoutInterval: 10.0)
  }
  
  func getShows(date:Date, completion: @escaping (Result<Day>) -> ()) {

    let request = self.buildRequest(from: ShowApi.schedule(country: "US", date: date))
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
      let response = response as? HTTPURLResponse
      DispatchQueue.main.async {
        if let e = error {
          completion(.failure(e.localizedDescription))
        } else if let response = response {
          let result = self.handleNetworkResponse(response)
          switch result {
          case .success:
            guard let data = data else {
              completion(.failure(NetworkResponse.noData.rawValue))
              return
            }
            let json = JSON(data)
            guard let jsonArray = json.array else {
              completion(.failure(NetworkResponse.badRequest.rawValue))
              return
            }
            completion(.success(Day.get(rawArray: jsonArray, date: date)))
          case .failure(let networkFailureError):
            completion(.failure(networkFailureError))
          }
        }
      }
    })
    task.resume()
  }
}

extension NetworkManager {
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String>{
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outdated.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
    }
  }
}

