//
//  ExploreDataLoaderTests.swift.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import XCTest
@testable import ANF_Code_Test

final class ExploreDataLoaderTests: XCTestCase {
    
    private var loader: ExploreDataLoader!
    
    private func tempFileURL(named name: String) -> URL {
        Bundle(for: type(of: self)).bundleURL.appendingPathComponent("\(name).json")
    }
    
    private func createTempJSON(named name: String, content: String) throws {
        let url = tempFileURL(named: name)
        try content.data(using: .utf8)?.write(to: url)
    }
    
    private func deleteTempJSON(named name: String) {
        try? FileManager.default.removeItem(at: tempFileURL(named: name))
    }
        
    func test_load_success_withValidJSON() throws {
        
        let validJSON = """
            [
              {
                "title": "TOPS STARTING AT $12",
                "backgroundImage": "anf-20160527-app-m-shirts.jpg",
                "content": [
                  {
                    "target": "https://www.abercrombie.com/shop/us/mens-new-arrivals",
                    "title": "Shop Men"
                  },
                  {
                    "target": "https://www.abercrombie.com/shop/us/womens-new-arrivals",
                    "title": "Shop Women"
                  }
                ],
                "promoMessage": "USE CODE: 12345",
                "topDescription": "A&F ESSENTIALS",
                "bottomDescription": "*In stores & online."
              }
            ]
            """
        
        try createTempJSON(named: "exploreData", content: validJSON)
        
        loader = ExploreDataLoader(localFileName: "exploreData")
        
        let exp = expectation(description: "load")
        
        loader.load { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 10)
                XCTAssertEqual(items.first?.title, "TOPS STARTING AT $12")
                XCTAssertEqual(items.first?.content?.count, 2)
                XCTAssertEqual(items.first?.content?.first?.title, "Shop Men")
                XCTAssertEqual(items.first?.promoMessage, "USE CODE: 12345")
                
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        deleteTempJSON(named: "test_exploreData")
    }
    
    func test_load_fails_whenFileNotFound() {
        
        loader = ExploreDataLoader(localFileName: "file_does_not_exist")
        
        let exp = expectation(description: "fileMissing")
        
        loader.load { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, -2)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_fails_withInvalidJSON() throws {
        
        let invalidJSON = """
            { "invalid": true }   // Not an array → decoding should fail
            """
        
        try createTempJSON(named: "invalid_exploreData", content: invalidJSON)
        
        loader = ExploreDataLoader(localFileName: "invalid_exploreData")
        
        let exp = expectation(description: "invalidJSON")
        
        loader.load { result in
            switch result {
            case .success:
                XCTFail("Expected decoding failure")
            case .failure:
                XCTAssertTrue(true)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        deleteTempJSON(named: "invalid_exploreData")
    }
    
    func test_load_fails_whenNoSourceProvided() {
        
        loader = ExploreDataLoader(localFileName: nil)
        
        let exp = expectation(description: "noSource")
        
        loader.load { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, -1)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
