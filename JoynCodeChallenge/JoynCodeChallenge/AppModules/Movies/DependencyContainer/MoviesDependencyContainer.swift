//
//  MoviesDependencyContainer.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/30/23.
//

import SwiftUI

class MoviesDependencyContainer {
        
    @MainActor
    var moviesListView: some View {
        MoviesListView(viewModel: moviesListViewModel, movieDetailViewFactory: createDetailView(movie:))
    }
    
    @MainActor
    private var moviesListViewModel: MoviesListViewModel {
        MoviesListViewModel(repository: moviesRepository)
    }
    
    @MainActor
    private func createDetailView(movie: MoviePresentationModel) -> MovieDetailView {
        MovieDetailView(viewModel: createDetailViewModel(movie: movie))
    }
    
    @MainActor
    private func createDetailViewModel(movie: MoviePresentationModel) -> MovieDetailViewModel {
        MovieDetailViewModel(repository: moviesRepository, movie: movie)
    }
    
    private lazy var moviesRepository: MoviesRepositoryProtocol = {
        MoviesRepository(remoteDataSource: moviesRemoteDataSource)
    }()
    
    private var moviesRemoteDataSource: MoviesRemoteDataSource {
        MoviesURLSessionDataSource(networkService: URLSessionService())
    }
}
