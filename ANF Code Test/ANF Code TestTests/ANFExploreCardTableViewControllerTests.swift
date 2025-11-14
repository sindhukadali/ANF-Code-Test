//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    var testInstance: ANFExploreCardTableViewController!
    
    override func setUp() {
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController
        testInstance.loadViewIfNeeded()
        testInstance.viewDidLoad()
    }

    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeTen() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssert(numberOfRows == 10, "table view should have 10 cells")
    }
    
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let title = firstCell.viewWithTag(1) as? UILabel
        XCTAssert(title?.text?.count ?? 0 > 0, "title should not be blank")
    }
    
    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let imageView = firstCell.viewWithTag(2) as? UIImageView
        XCTAssert(imageView?.image != nil, "image view image should not be nil")
    }
    
    func test_topDescription_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let label = firstCell.viewWithTag(3) as? UILabel
        
        XCTAssertNotNil(label, "Top description label should not be nil")
        XCTAssertEqual(label?.font.pointSize, 13, "Top description font size should be 13")
    }

    func test_title_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let titleLabel = firstCell.viewWithTag(1) as? UILabel
        
        XCTAssertNotNil(titleLabel, "Title label should not be nil")
        XCTAssertEqual(titleLabel?.font.pointSize, 17, "Title font size should be 17")
        let fontTraits = titleLabel?.font.fontDescriptor.symbolicTraits
        let isBold = fontTraits?.contains(.traitBold) ?? false
        XCTAssertTrue(isBold, "Title font should be bold")
    }

    func test_promoMessage_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let promoLabel = firstCell.viewWithTag(4) as? UILabel
        
        XCTAssertNotNil(promoLabel, "Promo message label should not be nil")
        XCTAssertEqual(promoLabel?.font.pointSize, 11, "Promo message font size should be 11")
    }

    func test_bottomDescription_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let bottomDescriptionLabel = firstCell.viewWithTag(5) as? UILabel
        
        XCTAssertNotNil(bottomDescriptionLabel, "Bottom description label should not be nil")
        XCTAssertEqual(bottomDescriptionLabel?.font.pointSize, 13, "Bottom description font size should be 13")
    }

}
