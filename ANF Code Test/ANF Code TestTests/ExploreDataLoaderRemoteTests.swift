//
//  ExploreDataLoaderRemoteTests.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import XCTest
@testable import ANF_Code_Test

final class StubURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = StubURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let data = StubURLProtocol.stubResponseData ?? Data()
            client?.urlProtocol(self, didLoad: data)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() { }
}

final class ExploreDataLoaderRemoteTests: XCTestCase {

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: config)
    }

    func test_loadFromRemote_success() throws {
        let json = """
        [ { "title": "TITLE", "backgroundImage": "img.jpg" } ]
        """
        StubURLProtocol.stubResponseData = Data(json.utf8)
        StubURLProtocol.stubError = nil

        let session = makeSession()
        let url = URL(string: "https://example.com/test.json")!
        let loader = ExploreDataLoader(remoteURL: url, urlSession: session)

        let exp = expectation(description: "remoteSuccess")
        loader.load { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items.first?.title, "TITLE")
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_loadFromRemote_networkError() throws {
        StubURLProtocol.stubResponseData = nil
        StubURLProtocol.stubError = NSError(domain: "test", code: 42, userInfo: nil)

        let session = makeSession()
        let url = URL(string: "https://example.com/test.json")!
        let loader = ExploreDataLoader(remoteURL: url, urlSession: session)

        let exp = expectation(description: "remoteError")
        loader.load { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "test")
                XCTAssertEqual((error as NSError).code, 42)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
}
