//
//  FeedDetailsView.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit
import Toast_Swift

class FeedDetailsView: UIView {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: FeedDetailsViewModel!
    var delegate: FeedViewDelegate?
    
    private lazy var loadingView: UIView = {
        let loadingView = UIActivityIndicatorView(frame: .zero)
        loadingView.bounds.size.height = 40
        loadingView.color = .black
        loadingView.startAnimating()
        return loadingView
    }()
    
    //MARK: - Public Methods
    
    func setup(with hotNewsViewModel: HotNewsViewModel, and delegate: FeedViewDelegate) {
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: FeedCell.nibName, bundle: Bundle.main),
                           forCellReuseIdentifier: FeedCell.nibName)
        tableView.register(UINib(nibName: CommentCell.nibName, bundle: Bundle.main),
                           forCellReuseIdentifier: CommentCell.nibName)
        
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        self.viewModel = FeedDetailsViewModel(with: hotNewsViewModel, and: self)
        viewModel.loadComments()
    }
}

extension FeedDetailsView: FeedViewModelDelegate {
    func onLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = loading ? self.loadingView : nil
        }
    }
    func onLoadSucessful() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FeedDetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.viewModel(for: indexPath)
        
        switch cellViewModel.type {
        case .hotNews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.nibName, for: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
            
            cell.setup(viewModel: cellViewModel)
            
            return cell
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.nibName, for: indexPath) as? CommentCell else { fatalError("Cell is not of type CommentCell!") }
            
            cell.setup(viewModel: cellViewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.viewModel(for: indexPath).type {
        case .hotNews:
            return 400.0
        default:
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.viewModel(for: indexPath)
        
        switch cellViewModel.type {
        case .hotNews:
            delegate?.didTap(with: cellViewModel)
        case .comment:
            return
        }
    }
}
