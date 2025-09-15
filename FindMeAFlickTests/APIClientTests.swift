//
//  URLProtocolStub.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import XCTest
@testable import FavoriteMovies

final class URLProtocolStub: URLProtocol {
    static var stubbedData: Data?
    static var stubbedResponse: URLResponse?
    static var stubbedError: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let error = Self.stubbedError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = Self.stubbedResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = Self.stubbedData {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    override func stopLoading() {}
}

class APIClientTests: XCTestCase {
    func testFetchPopular_parsesMovies() {
        // sample minimal JSON
        let json = """
        {
         "page":1,
         "results":[
            {
             "id": 1,
             "title": "Test Movie",
             "poster_path": "/abc.jpg",
             "overview": "desc",
             "release_date": "2020-01-01",
             "vote_average": 7.5
            }
         ],
         "total_pages":1,
         "total_results":1
        }
        """.data(using: .utf8)!
        
        URLProtocolStub.stubbedData = json
        URLProtocolStub.stubbedResponse = HTTPURLResponse(url: URL(string:"https://api.themoviedb.org")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let client = APIClient(session: session)
        let exp = expectation(description: "fetch")
        client.fetchPopular { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Test Movie")
            case .failure(let err):
                XCTFail("expected success, got \(err)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
