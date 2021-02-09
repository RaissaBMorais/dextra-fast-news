//
//  HotNewsRequest.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

struct ListingRequest {
    let after: String?
    let limit: Int
    
    init(after: String?, limit: Int = 5) {
        self.after = after
        self.limit = limit
    }

    func params() -> [String: Any] {
        var body: [String: Any] = [:]
        body["after"] = after
        body["limit"] = limit
        return body
    }
}
