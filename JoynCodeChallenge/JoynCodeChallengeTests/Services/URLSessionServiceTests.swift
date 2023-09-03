//
//  URLSessionServiceTests.swift
//  JoynCodeChallengeTests
//
//  Created by Hamed Moosaei on 7/31/23.
//

import XCTest
@testable import JoynCodeChallenge

final class URLSessionServiceTests: XCTestCase {
    
    var service: URLSessionService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        service = URLSessionService()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        service = nil
    }
    
    func testRequest_WithValidEndPoint_ShouldDecodeResponse() async {
        let endPoint = MockEndPoint.valid
        
        let mockResponse = MockResponse(message: "Success")
        let jsonData = try! JSONEncoder().encode(mockResponse)
        
        let mockURLSession = MockURLSession()
        mockURLSession.data = jsonData
        mockURLSession.response = HTTPURLResponse(url: URL(string: "google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        service.urlSession = mockURLSession
        
        do {
            let response: MockResponse = try await service.request(endPoint: endPoint)
            
            XCTAssertEqual(response.message, "Success")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequest_WithInvalidEndPoint_ShouldThrowError() {
        let endPoint = MockEndPoint.invalid
        
        let mockURLSession = MockURLSession()
        mockURLSession.error = NSError(domain: "URL Can Not Be Created", code: 0)
        
        service.urlSession = mockURLSession
        
        let expectation = XCTestExpectation(description: "Request completion")
        
        let task = Task.detached {
            do {
                let _: MockResponse = try await self.service.request(endPoint: endPoint)
                XCTFail("Expected error to be thrown.")
            } catch {
                XCTAssertEqual((error as NSError).domain, "URL Can Not Be Created")
                XCTAssertEqual((error as NSError).code, 0)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        task.cancel()
    }
    
    func testRequest_WithEmptyData_ShouldThrowError() async throws {
        let endPoint: EndPoint = MockEndPoint.valid
        
        let mockURLSession = MockURLSession()
        mockURLSession.data = Data() // Empty data
        service.urlSession = mockURLSession
        
        do {
            let _: MockResponse = try await self.service.request(endPoint: endPoint)
            XCTFail("Expected error to be thrown.")
        } catch {
            
        }
    }
    
}

struct MockResponse: Codable {
    let message: String
}

enum MockError: Error {
    case requestFailed
}

enum MockEndPoint: EndPoint {
    case valid
    case invalid
    
    var path: String {
        switch self {
        case .valid:
            return "/api/data"
        case .invalid:
            return "/api/invalid"
        }
    }
    var httpMethod: HTTPMethod {
        .get
    }
    var httpHeaders: [String : String]? {
        nil
    }
    
    var httpBody: Encodable? {
        nil
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            throw MockError.requestFailed
        }
        
        return (data, response)
    }
}
