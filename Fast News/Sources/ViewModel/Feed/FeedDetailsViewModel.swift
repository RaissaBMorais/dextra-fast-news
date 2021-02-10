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
    private var provider: ProviderProcotol!
    
    internal var items = [TypeProtocol]() {
        didSet {
            delegate?.onLoadSucessful()
        }
    }
    var delegate: FeedViewModelDelegate?
    
    init (with hotNewsViewModel: HotNewsViewModel,
          delegate: FeedViewModelDelegate?,
          provider: ProviderProcotol = HotNewsProvider.shared) {
        self.hotNewsID = hotNewsViewModel.id
        self.items = [hotNewsViewModel]
        self.delegate = delegate
        self.provider = provider
    }
    
    func itemsCount() -> Int {
        return items.count
    }
    
    func viewModel(for indexPath: IndexPath) -> TypeProtocol {
        items[indexPath.row]
    }

    func loadComments() {
        delegate?.onLoading(true)
        provider.hotNewsComments(id: hotNewsID) { completion in
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
