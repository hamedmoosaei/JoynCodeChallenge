//
//  MoviesRepository.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func fetchMovies() async throws -> [MovieBusinessModel]
}

struct MoviesRepository: MoviesRepositoryProtocol {
    
    private var remoteDataSource: MoviesRemoteDataSource
    
    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchMovies() async throws -> [MovieBusinessModel] {
        try await remoteDataSource.provideMoviesListData().map(mapMoviesDecodableToBusinessModel(_:))
    }
    
    private func mapMoviesDecodableToBusinessModel(_ model: MovieDecodableModel) -> MovieBusinessModel {
        MovieBusinessModel(
            imageURL: model.imageURL + "/profile:" + Constants.profile + "/wm:" + String(model.tvShow.channelId),
            titleDefault: model.titleDefault,
            tvShowTitle: model.tvShow.titleDefault,
            channelId: model.tvShow.channelId)
    }
}
