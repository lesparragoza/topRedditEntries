//
//  NetworkingManager.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 12/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

protocol NetworkManagerRequestProtocol {
    var url: String { get }
    var headers: [String: String]? { get }
    var parameters: String? { get }
    var httpMethod: NetworkManager.HTTPMethod { get }
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ requestObject: NetworkManagerRequestProtocol, responseType: T.Type, completion: @escaping (Any?, Error?) -> Void)
}


class NetworkManager: NetworkManagerProtocol {
    
    private var baseUrl: String = "https://api.reddit.com"

    private var defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func request<T: Decodable>(_ requestObject: NetworkManagerRequestProtocol, responseType: T.Type, completion: @escaping (Any?, Error?) -> Void) {
        let stringURL = baseUrl + requestObject.url
        dataTask?.cancel()
        if let url = URL(string: stringURL) {
            var request = URLRequest(url: url)
            request.httpMethod = requestObject.httpMethod.rawValue
            request.allHTTPHeaderFields = requestObject.headers
            request.httpBody = requestObject.parameters?.data(using: .utf8)
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    completion(nil, error)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                        completion(try? JSONDecoder().decode(responseType, from: data), nil)
                }
            }
            dataTask?.resume()
        }
    }
    
    enum HTTPMethod: String {
        case post = "POST"
        case delete = "DELETE"
        case get = "GET"
        case put = "PUT"
    }
}
