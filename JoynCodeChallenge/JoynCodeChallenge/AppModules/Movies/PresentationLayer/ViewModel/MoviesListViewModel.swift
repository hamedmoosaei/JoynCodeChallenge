//
//  MoviesListViewModel.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

@MainActor
class MoviesListViewModel: ObservableObject {
    @Published var movies: [MoviePresentationModel] = []
    
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
        fetchMovies()
    }
    
    func fetchMovies() {
        Task {
            isLoading = true
            do {
                self.movies = try await repository.fetchMovies().map(mapMoviesBusinessToPresentaionModel(_:))
                isError = false
            } catch {
                isError = true
            }
            isLoading = false
        }
    }
    
    nonisolated private func mapMoviesBusinessToPresentaionModel(_ model: MovieBusinessModel) -> MoviePresentationModel {
        MoviePresentationModel(imageURL: model.imageURL, tvShowTitle: model.tvShowTitle, titleDefault: model.titleDefault)
    }
}
