//
//  FeedDetailsUITests.swift
//  Fast NewsUITests
//
//  Created by Raissa Morais on 2/10/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import XCTest

class FeedDetailsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()

    }

    func test_NavigateToDetails_WithHotNewsLoaded() throws {
        let app = XCUIApplication()
        
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: app.tables.cells["FeedCell"].firstMatch, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Look for feed cell and tap to navigate to details
        let feedCellMain = app.tables.cells["FeedCell"].firstMatch
        XCTAssertEqual(feedCellMain.exists, true, "Did not navigate find feed cell")
        feedCellMain.tap()

        // Look for navigation title to identify if user is in details screen
        let feedDetailsTitle = XCUIApplication().navigationBars["Fast_News.FeedDetailsView"].buttons["Fast News"]
        XCTAssertEqual(feedDetailsTitle.exists, true, "Did not navigate to details")

        // Look for feed cell again to check if screen was loaded with cell already in it
        let feedCellDetails = app.tables.cells["FeedCell"].firstMatch
        XCTAssertEqual(feedCellDetails.exists, true, "Did not load screen with feed cell")
    }
}
