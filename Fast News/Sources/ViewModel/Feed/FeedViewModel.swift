//
//  FeedViewModel.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

class FeedViewModel {
    internal var hotNewsViewModels = [HotNewsViewModel]() {
        didSet {
            delegate?.onLoadSucessful()
        }
    }
    var delegate: FeedViewModelDelegate?

    internal var isFetchingData = false {
        didSet {
            delegate?.onLoading(isFetchingData)
        }
    }
    internal var request = ListingRequest(after: "")

    init(with delegate: FeedViewModelDelegate) {
        self.delegate = delegate
    }
    
    func itemsCount() -> Int {
        return hotNewsViewModels.count
    }
    
    func viewModel(for indexPath: IndexPath) -> HotNewsViewModel {
        hotNewsViewModels[indexPath.row]
    }
    
    func loadNews(nextPage: Bool = false) {
        guard request.after != nil, !isFetchingData else { return }
        isFetchingData = true

        HotNewsProvider.shared.hotNews(parameters: request.params()) { completion in
            do {
                self.isFetchingData = false
                let response = try completion()
                if let after = response?.after {
                    self.request = ListingRequest(after: after)
                }
                self.hotNewsViewModels += response?.toHotNews().map { HotNewsViewModel(hotNews: $0) } ?? []
            } catch {
                self.delegate?.onLoadFailed(with: error)
            }
        }
    }
}
