//
//  FeedDetailsViewModel.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

class FeedDetailsViewModel {
    private var hotNewsID: String!
    
    internal var items = [TypeProtocol]() {
        didSet {
            delegate?.onLoadSucessful()
        }
    }
    var delegate: FeedViewModelDelegate?
    
    init (with hotNewsViewModel: HotNewsViewModel, and delegate: FeedViewModelDelegate) {
        self.hotNewsID = hotNewsViewModel.id
        self.items = [hotNewsViewModel]
        self.delegate = delegate
    }
    
    var itemsCount: Int {
        return items.count
    }
    
    func viewModel(for indexPath: IndexPath) -> TypeProtocol {
        items[indexPath.row]
    }

    func loadComments() {
        delegate?.onLoading(true)
        HotNewsProvider.shared.hotNewsComments(id: hotNewsID) { completion in
            self.delegate?.onLoading(false)
            do {
                let response = try completion()
                self.items += response?.toComments().map { CommentViewModel(comment: $0) } ?? []
            } catch {
                self.delegate?.onLoadFailed(with: error)
            }
        }
    }
}
