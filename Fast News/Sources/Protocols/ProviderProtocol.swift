//
//  ProviderProtocol.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

//MARK: - Type alias
typealias HotNewsCallback = ( () throws -> HotNewsResponse?) -> Void
typealias HotNewsCommentsCallback = ( () throws -> CommentsResponse?) -> Void

protocol ProviderProcotol {
    func hotNews(parameters: [String: Any]?, completion: @escaping HotNewsCallback)
    func hotNewsComments(id: String, completion: @escaping HotNewsCommentsCallback)
}
