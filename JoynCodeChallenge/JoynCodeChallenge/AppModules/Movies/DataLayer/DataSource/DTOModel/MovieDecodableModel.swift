//
//  MovieDecodableModel.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

// MARK: - Movie
struct MovieDecodableModel: Codable {
    let imageURL: String
    let titleDefault: String
    let tvShow: TvShow
}

// MARK: - TvShow
struct TvShow: Codable {
    let titleDefault: String
    let channelId: Int
}
