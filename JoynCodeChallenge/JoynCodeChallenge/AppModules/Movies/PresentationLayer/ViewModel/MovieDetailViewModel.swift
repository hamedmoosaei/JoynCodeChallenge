//
//  MovieDetailViewModel.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    private let repository: MoviesRepositoryProtocol
    @Published var movie: MoviePresentationModel
    
    init(repository: MoviesRepositoryProtocol, movie: MoviePresentationModel) {
        self.repository = repository
        self.movie = movie
    }
}
