//
//  URLSessionService.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endPoint: any EndPoint) async throws -> T
}

struct URLSessionService: NetworkService {
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func request<T: Decodable>(endPoint: EndPoint) async throws -> T {
        guard let urlRequest = createUrlRequest(endPoint: endPoint) else { throw NSError(domain: "URL Can Not Be Created", code: 0) }
        let data = try await urlSession.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data.0)
    }
    
    private func createUrlRequest(endPoint: EndPoint) -> URLRequest? {
        guard let url = URL(string: Constants.baseUrl + endPoint.path) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let body = endPoint.httpBody {
            let jsonData = try? encoder.encode(body)
            urlRequest.httpBody = jsonData
        }
        endPoint.allHeaders.forEach({
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        })
        return urlRequest
    }
}

// For testing purpose
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
