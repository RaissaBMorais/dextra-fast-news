//
//  FeedDetailsViewModelTests.swift
//  Fast NewsTests
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

class FeedDetailsViewModelTests: XCTestCase {
    var sut: FeedDetailsViewModel!
    var hotNewsViewModel: HotNewsViewModel!
    var provider: MockProvider!

    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        let commentsPath = testBundle.path(forResource: "hotNewsCommentsMock", ofType: "json")
        let commentsData = try? Data(contentsOf: URL(fileURLWithPath: commentsPath!), options: .alwaysMapped)

        provider = MockProvider()
        provider.commentsData = commentsData
        
        hotNewsViewModel = HotNewsViewModel(hotNews: HotNews())
        sut = FeedDetailsViewModel(with: hotNewsViewModel, delegate: nil, provider: provider)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_CorrectCountAfterInitializing() {
        XCTAssertEqual(sut.itemsCount(), 1)
    }
    
    func test_FirstViewModelIsHotNews() {
        XCTAssertEqual(sut.itemsCount(), 1)
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertEqual(self.sut.viewModel(for: indexPath).type, .hotNews)
        sut.loadComments()
        XCTAssertEqual(sut.itemsCount(), 2)
        XCTAssertEqual(self.sut.viewModel(for: indexPath).type, .hotNews)
    }
    
    func test_UpdateCountAfterLoadComments() {
        XCTAssertEqual(sut.itemsCount(), 1)
        sut.loadComments()
        XCTAssertEqual(sut.itemsCount(), 2)
    }
    
    func test_MaintainDataIfRequestReturnsNil() {
        provider.returnNil = true
        XCTAssertEqual(self.sut.itemsCount(), 1)
        sut.loadComments()
        XCTAssertEqual(self.sut.itemsCount(), 1)
    }

    func test_MaintainDataIfRequestReturnsError() {
        provider.failComments = true
        XCTAssertEqual(self.sut.itemsCount(), 1)
        sut.loadComments()
        XCTAssertEqual(self.sut.itemsCount(), 1)
    }
}
