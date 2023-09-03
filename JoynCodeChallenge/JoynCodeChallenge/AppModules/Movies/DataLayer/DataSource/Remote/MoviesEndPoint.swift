//
//  MoviesEndPoint.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

struct MoviesEndPoint: EndPoint {
    var path: String = "/popular/videos"
    var httpMethod: HTTPMethod = .get
    var httpHeaders: [String : String]? = nil
    var httpBody: Encodable?
}
