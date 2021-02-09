//
//  FeedDetailsViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {
    
    //MARK: - Properties
    var hotNewsViewModel: HotNewsViewModel!
    var mainView: FeedDetailsView {
        guard let view = self.view as? FeedDetailsView else {
            fatalError("View is not of type FeedDetailsView!")
        }
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        mainView.setup(with: hotNewsViewModel, and: self)
    }
}

extension FeedDetailsViewController: FeedViewDelegate {
    func didTap(with viewModel: TypeProtocol) {
        guard let viewModel = viewModel as? HotNewsViewModel else { return }
        if let url = URL(string: viewModel.url) {
            UIApplication.shared.open(url)
        }
    }
}
