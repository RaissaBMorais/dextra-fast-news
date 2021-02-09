//
//  CommentsResponse.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

class CommentsResponse: Codable {
    class CommentResponse: Codable {
        var comment: Comment
        
        private enum CodingKeys: String, CodingKey {
            case comment = "data"
        }
    }
    var data: [CommentResponse]
    
    private enum CodingKeys: String, CodingKey {
        case data = "children"
    }
    
    func toComments() -> [Comment] {
        return data.map { $0.comment }
    }
}
