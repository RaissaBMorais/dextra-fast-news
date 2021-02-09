//
//  HotNewsResponse.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

class HotNewsResponse: Codable {
    class HotNewResponse: Codable {
        var hotNew: HotNews
        
        private enum CodingKeys: String, CodingKey {
            case hotNew = "data"
        }
    }
    var data: [HotNewResponse]
    var after: String?
    
    private enum CodingKeys: String, CodingKey {
        case data = "children"
        case after
    }
    
    func toHotNews() -> [HotNews] {
        return data.map { $0.hotNew }
    }
}
