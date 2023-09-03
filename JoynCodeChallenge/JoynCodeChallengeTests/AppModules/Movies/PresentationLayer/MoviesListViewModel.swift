//
//  MoviesListViewModel.swift
//  JoynCodeChallengeTests
//
//  Created by Hamed Moosaei on 7/31/23.
//

import XCTest
@testable import JoynCodeChallenge

@MainActor
final class MoviesListViewModelTests: XCTestCase {
    
    var mockRepository: MockMoviesRepository!
    var viewModel: MoviesListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockMoviesRepository()
        viewModel = MoviesListViewModel(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchMovies_Success() {
        let movie1 = MovieBusinessModel(imageURL: "url1", titleDefault: "Movie 1", tvShowTitle: "TV Show 1", channelId: 1)
        let movie2 = MovieBusinessModel(imageURL: "url2", titleDefault: "Movie 2", tvShowTitle: "TV Show 2", channelId: 2)
        
        mockRepository.movies = [movie1, movie2]
                
        viewModel.fetchMovies()
        
        let predication = NSPredicate { _, _ in
            self.mockRepository.fetchMovieCalled
        }
        
        let expectations = [XCTNSPredicateExpectation(predicate: predication, object: mockRepository)]
        
        wait(for: expectations, timeout: 5)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isError)
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[0].titleDefault, "Movie 1")
        XCTAssertEqual(viewModel.movies[1].titleDefault, "Movie 2")
        XCTAssertEqual(viewModel.movies[0].tvShowTitle, "TV Show 1")
        XCTAssertEqual(viewModel.movies[1].tvShowTitle, "TV Show 2")
        
    }
    
    func testFetchMovies_Failure() {
        let mockRepository = MockMoviesRepository()
        mockRepository.shouldThrowError = true
        let viewModel = MoviesListViewModel(repository: mockRepository)
        
        
        viewModel.fetchMovies()
        
        let predication = NSPredicate { _, _ in
            self.mockRepository.fetchMovieCalled
        }
        
        let expectations = [XCTNSPredicateExpectation(predicate: predication, object: mockRepository)]
        
        wait(for: expectations, timeout: 5)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isError)
        XCTAssertTrue(viewModel.movies.isEmpty)
        
    }
}

class MockMoviesRepository: MoviesRepositoryProtocol {
    var movies: [MovieBusinessModel]?
    var shouldThrowError = false
    var fetchMovieCalled = false
    
    func fetchMovies() async throws -> [MovieBusinessModel] {
        fetchMovieCalled = true
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        guard let movies = movies else {
            return []
        }
        return movies
    }
}
