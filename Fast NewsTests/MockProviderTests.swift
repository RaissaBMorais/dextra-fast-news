//
//  Fast_NewsTests.swift
//  Fast NewsTests
//
//  Created by Lucas Moreton on 16/09/19.
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

class MockProviderTests: XCTestCase {
    var sut: MockProvider!
    
    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        let hotNewsPath = testBundle.path(forResource: "hotNewsMock", ofType: "json")
        let hotNewsData = try? Data(contentsOf: URL(fileURLWithPath: hotNewsPath!),
                                    options: .alwaysMapped)

        let commentsPath = testBundle.path(forResource: "hotNewsCommentsMock", ofType: "json")
        let commentsData = try? Data(contentsOf: URL(fileURLWithPath: commentsPath!), options: .alwaysMapped)

        sut = MockProvider()
        sut.newsData = hotNewsData
        sut.commentsData = commentsData
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_ParseHotNews_AndReturnsCorrectResponse() {
        sut.hotNews(parameters: nil) { completion in
            do {
                let response = try completion()
                XCTAssertNotNil(response, "Response should not be nil")
                XCTAssertEqual(response!.toHotNews().count, 2)
            } catch {
                XCTFail("Provider threw error: \(error.localizedDescription)")
            }
        }
    }
    
    func test_ParseComments_AndReturnsCorrectResponse() {
        sut.hotNewsComments(id: "") { completion in
            do {
                let response = try completion()
                XCTAssertNotNil(response, "Response should not be nil")
                XCTAssertEqual(response!.toComments().count, 1)
            } catch {
                XCTFail("Provider threw error: \(error.localizedDescription)")
            }
        }
    }
    
    func test_ThrowsError() {
        sut.failNews = true
        sut.failComments = true
    
        sut.hotNews(parameters: nil) { completion in
            do {
                _ = try completion()
                XCTFail("Should have thrown error")
            } catch {
                XCTAssertEqual(error as! MockError, .failNews)
            }
        }
        
        sut.hotNewsComments(id: "") { completion in
            do {
                _ = try completion()
                XCTFail("Should have thrown error")
            } catch {
                XCTAssertEqual(error as! MockError, .failComments)
            }
        }
    }
    
    func test_ReturnsNil() {
        sut.returnNil = true
        
        sut.hotNews(parameters: nil) { completion in
            do {
                let response = try completion()
                XCTAssertNil(response, "Response should be nil")
            } catch {
                XCTFail("Provider threw error: \(error.localizedDescription)")
            }
        }
        
        sut.hotNewsComments(id: "") { completion in
            do {
                let response = try completion()
                XCTAssertNil(response, "Response should be nil")
            } catch {
                XCTFail("Provider threw error: \(error.localizedDescription)")
            }
        }
    }
}
