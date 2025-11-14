//
//  ANFExploreDataModelTests2.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import XCTest
@testable import ANF_Code_Test

final class ANFExploreDataModelTests: XCTestCase {

    func test_fullDecoding_success() throws {
        let json = """
        [
          {
            "title": "TITLE",
            "backgroundImage": "image.jpg",
            "topDescription": "Top",
            "promoMessage": "Promo",
            "bottomDescription": "Bottom",
            "content": [
              { "target": "https://a", "title": "Link" }
            ]
          }
        ]
        """

        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode([ANFExploreData].self, from: data)
        XCTAssertEqual(decoded.count, 1)
        let first = decoded[0]
        XCTAssertEqual(first.title, "TITLE")
        XCTAssertEqual(first.backgroundImage, "image.jpg")
        XCTAssertEqual(first.topDescription, "Top")
        XCTAssertEqual(first.promoMessage, "Promo")
        XCTAssertEqual(first.bottomDescription, "Bottom")
        XCTAssertEqual(first.content?.count, 1)
        XCTAssertEqual(first.content?.first?.target, "https://a")
    }

    func test_missingOptionalFields_decodeSuccessfully() throws {
        let json = """
        [
          {
            "title": "TITLE",
            "backgroundImage": "image.jpg"
          }
        ]
        """

        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode([ANFExploreData].self, from: data)
        XCTAssertEqual(decoded.count, 1)
        let first = decoded[0]
        XCTAssertEqual(first.title, "TITLE")
        XCTAssertEqual(first.backgroundImage, "image.jpg")
        XCTAssertNil(first.topDescription)
        XCTAssertNil(first.promoMessage)
        XCTAssertNil(first.bottomDescription)
        XCTAssertNil(first.content)
    }

    func test_emptyContentArray_decodesAsEmpty() throws {
        let json = """
        [
          {
            "title": "TITLE",
            "backgroundImage": "image.jpg",
            "content": []
          }
        ]
        """

        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode([ANFExploreData].self, from: data)
        XCTAssertEqual(decoded.first?.content?.count, 0)
    }
}
