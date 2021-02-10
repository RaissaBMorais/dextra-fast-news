//
//  FeedViewModelTests.swift
//  Fast NewsTests
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

class FeedViewModelTests: XCTestCase {
    var sut: FeedViewModel!
    var provider: MockProvider!

    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        let hotNewsPath = testBundle.path(forResource: "hotNewsMock", ofType: "json")
        let hotNewsData = try? Data(contentsOf: URL(fileURLWithPath: hotNewsPath!),
                                    options: .alwaysMapped)

        provider = MockProvider()
        provider.newsData = hotNewsData
        
        sut = FeedViewModel(with: nil, provider: provider)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_UpdateCountAfterLoadItems() {
        XCTAssertEqual(sut.itemsCount(), 0)
        sut.loadNews()
        XCTAssertEqual(sut.itemsCount(), 2)
    }
    
    func test_UpdateCountAfterLoadNextPage() {
        sut.loadNews()
        XCTAssertEqual(sut.itemsCount(), 2)
        sut.loadNews(nextPage: true)
        XCTAssertEqual(sut.itemsCount(), 4)
    }
    
    func test_ResetCountAfterLoad_WithNextPageFalse() {
        sut.loadNews()
        XCTAssertEqual(sut.itemsCount(), 2)
        sut.loadNews(nextPage: true)
        XCTAssertEqual(sut.itemsCount(), 4)
        sut.loadNews()
        XCTAssertEqual(sut.itemsCount(), 2)
    }
    
    func test_ReturnCorrectViewModel() {
        provider.hotNews(parameters: nil) { completion in
            self.sut.loadNews()
            let indexPath = IndexPath(row: 0, section: 0)

            let hotNewsVM = HotNewsViewModel(hotNews: try! completion()!.toHotNews().first!)
            XCTAssertEqual(self.sut.viewModel(for: indexPath).id, hotNewsVM.id)
        }
    }
    
    func test_UpdateNextPageReference() {
        XCTAssertEqual(self.sut.request.after, "")
        sut.loadNews()
        provider.hotNews(parameters: nil) { completion in
            let response = try! completion()
            XCTAssertEqual(self.sut.request.after, response!.after)
        }
    }
    
    func test_MaintainDataIfRequestReturnsNil() {
        provider.returnNil = true
        XCTAssertEqual(self.sut.request.after, "")
        XCTAssertEqual(self.sut.itemsCount(), 0)
        sut.loadNews()
        XCTAssertEqual(self.sut.request.after, "")
        XCTAssertEqual(self.sut.itemsCount(), 0)
    }

    func test_MaintainDataIfRequestReturnsError() {
        provider.failNews = true
        XCTAssertEqual(self.sut.request.after, "")
        XCTAssertEqual(self.sut.itemsCount(), 0)
        sut.loadNews()
        XCTAssertEqual(self.sut.request.after, "")
        XCTAssertEqual(self.sut.itemsCount(), 0)
    }
}
