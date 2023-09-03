//
//  MoviesURLSessionDataSourceTests.swift
//  JoynCodeChallengeTests
//
//  Created by Hamed Moosaei on 7/31/23.
//

import XCTest
@testable import JoynCodeChallenge

final class MovieURLSessionDataSourceTests: XCTestCase {
    
    var networkService: MockNetworkService!
    var dataSource: MoviesRemoteDataSource!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = MockNetworkService()
        dataSource = MoviesURLSessionDataSource(networkService: networkService)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        networkService = nil
        dataSource = nil
    }
    
    func testProvideMovieData_WithValidNetworkService_ShouldReturnMovieData() async throws {
        let networkService = MockNetworkService()
        let dataSource: MoviesRemoteDataSource = MoviesURLSessionDataSource(networkService: networkService)
        let expectedData = [
            MovieDecodableModel(imageURL: "imageUrl1", titleDefault: "titleDefault1", tvShow: TvShow(titleDefault: "default1", channelId: 1)),
            MovieDecodableModel(imageURL: "imageUrl2", titleDefault: "titleDefault2", tvShow: TvShow(titleDefault: "default2", channelId: 2))
        ]
        networkService.mockRequestResult = expectedData
        
        let movieData = try await dataSource.provideMoviesListData()
        
        let expectedMovie = expectedData[0]
        let movie = movieData[0]
        XCTAssertEqual(movie.imageURL, expectedMovie.imageURL)
        XCTAssertEqual(movie.titleDefault, expectedMovie.titleDefault)
    }
    
    func testProvideMovieData_WithNetworkError_ShouldThrowError() async throws {
        networkService.mockRequestError = NSError(domain: "NetworkFakeError", code: 0, userInfo: nil)
        
        do {
            let _ = try await dataSource.provideMoviesListData()
            XCTFail("Expected error to be thrown.")
        } catch let error {
            XCTAssertEqual((error as NSError).domain, "NetworkFakeError")
        }
    }
}

class MockNetworkService: NetworkService {
    var mockRequestResult: [MovieDecodableModel]?
    var mockRequestError: Error?
    
    func request<T: Decodable>(endPoint: EndPoint) async throws -> T {
        if let result = mockRequestResult as? T {
            return result
        } else if let error = mockRequestError {
            throw error
        } else {
            throw NSError(domain: "MockNetworkServiceError", code: 0, userInfo: nil)
        }
    }
}
