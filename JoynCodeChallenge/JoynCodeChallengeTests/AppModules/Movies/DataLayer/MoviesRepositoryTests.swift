//
//  MoviesRepositoryTests.swift
//  JoynCodeChallengeTests
//
//  Created by Hamed Moosaei on 7/31/23.
//

import XCTest
@testable import JoynCodeChallenge

final class MoviesRepositoryTests: XCTestCase {
    
    var mockDataSource: MockRemoteDataSource!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataSource = MockRemoteDataSource()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockDataSource = nil
    }

    func testFetchMovies_Success() async {
        let movie1 = MovieDecodableModel(imageURL: "url1", titleDefault: "Movie 1", tvShow: TvShow(titleDefault: "TV Show 1", channelId: 1))
        let movie2 = MovieDecodableModel(imageURL: "url2", titleDefault: "Movie 2", tvShow: TvShow(titleDefault: "TV Show 2", channelId: 2))
        mockDataSource.movies = [movie1, movie2]
        let repository = MoviesRepository(remoteDataSource: mockDataSource)

        do {
            let movies = try await repository.fetchMovies()

            XCTAssertEqual(movies.count, 2)
            XCTAssertEqual(movies[0].titleDefault, "Movie 1")
            XCTAssertEqual(movies[1].titleDefault, "Movie 2")
            XCTAssertEqual(movies[0].tvShowTitle, "TV Show 1")
            XCTAssertEqual(movies[1].tvShowTitle, "TV Show 2")
            XCTAssertEqual(movies[0].channelId, 1)
            XCTAssertEqual(movies[1].channelId, 2)
        } catch {
            XCTFail("Expected successful fetch, but threw error: \(error)")
        }
    }
    
    func testFetchMovies_Failure() async {
        mockDataSource.movies = nil
        let repository = MoviesRepository(remoteDataSource: mockDataSource)

        do {
            _ = try await repository.fetchMovies()

            XCTFail("Expected error, but fetchMovies succeeded.")
        } catch {
            // Expected to throw an error
        }
    }
}

class MockRemoteDataSource: MoviesRemoteDataSource {
    var movies: [MovieDecodableModel]?
    
    func provideMoviesListData() async throws -> [MovieDecodableModel] {
        guard let movies = movies else {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return movies
    }
}
