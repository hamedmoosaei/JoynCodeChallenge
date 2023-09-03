//
//  MoviesURLSessionDataSource.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

protocol MoviesRemoteDataSource {
    func provideMoviesListData() async throws -> [MovieDecodableModel]
}

struct MoviesURLSessionDataSource: MoviesRemoteDataSource {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func provideMoviesListData() async throws -> [MovieDecodableModel] {
        try await networkService.request(endPoint: MoviesEndPoint())
    }
}
