//
//  FeedViewViewModel.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation

protocol FeedViewViewModelDelegate {
    func onLoadCompleted()
    func onLoadFailed(with error: Error?)
}

class BaseListingViewModel {
    private var hotNewsViewModels = [HotNewsViewModel]() {
        didSet {
            delegate?.onLoadCompleted()
        }
    }
    var delegate: FeedViewViewModelDelegate?
    var isFetchingData = false
    private var request = ListingRequest(after: "")

    init(with delegate: FeedViewViewModelDelegate) {
        self.delegate = delegate
    }
    
    func newsCount() -> Int {
        return hotNewsViewModels.count
    }
    
    func viewModel(for indexPath: IndexPath) -> HotNewsViewModel {
        hotNewsViewModels[indexPath.row]
    }
    
    func loadNews(nextPage: Bool = false) {
        guard !isFetchingData else { return }
        isFetchingData = true
        print("is Fetching =  \(hotNewsViewModels.count)")
        
        HotNewsProvider.shared.service(endpoint: .hotNews,
                                    parameters: request.params(),
                             type: HotNewsResponse.self) { (completion) in
            self.isFetchingData = false
            do {
                if let response = try completion() {
                    self.request = ListingRequest(after: response.after)
                    self.hotNewsViewModels += response.toHotNews().map { HotNewsViewModel(hotNews: $0) }
                } else {
                    self.delegate?.onLoadFailed(with: nil)
                }
            } catch {
                self.delegate?.onLoadFailed(with: error)
            }
            print("finished Fetching \(self.hotNewsViewModels.count)")
        }
    }
}
