//
//  MockProvider.swift
//  Fast NewsTests
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation
@testable import Fast_News

enum MockError: Error {
    case failNews, failComments
}

class MockProvider: ProviderProcotol {
    var failNews = false
    var failComments = false
    var returnNil = false
    var newsData: Data!
    var commentsData: Data!

    func hotNews(parameters: [String : Any]?, completion: @escaping HotNewsCallback) {
        if failNews {
            completion { throw MockError.failNews }
        } else if returnNil {
            completion { nil }
        } else {
            do {
                let items = try JSONDecoder().decode(HotNewsResponse.self, from: newsData)
                completion { items }
            } catch {
                completion { throw error }
            }
        }
    }
    
    func hotNewsComments(id: String, completion: @escaping HotNewsCommentsCallback) {
        if failComments {
            completion { throw MockError.failComments }
        } else if returnNil {
            completion { nil }
        } else {
            do {
                let items = try JSONDecoder().decode(CommentsResponse.self, from: commentsData)
                completion { return items }
            } catch {
                completion { throw error }
            }
        }
    }
}
