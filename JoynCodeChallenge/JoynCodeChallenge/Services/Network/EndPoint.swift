//
//  EndPoint.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var httpHeaders: [String: String]? { get }
    
    var allHeaders: [String: String] { get }
        
    var httpBody: Encodable? { get }
}

extension EndPoint {
    var allHeaders: [String: String] {
        defaultHeaders.merging(httpHeaders ?? [:]) { (_, new) in new }
    }
    
    private var defaultHeaders: [String: String] {
        ["Content-Type": "application/json",
         "Accept": "application/json"]
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
