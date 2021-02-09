//
//  FeedView.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit
import Toast_Swift

class FeedView: UIView {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: FeedViewModel = {
        return FeedViewModel(with: self)
    }()
    var delegate: FeedViewDelegate?
    
    private lazy var loadingView: UIView = {
        let loadingView = UIActivityIndicatorView(frame: .zero)
        loadingView.bounds.size.height = 40
        loadingView.color = .black
        loadingView.startAnimating()
        return loadingView
    }()

    //MARK: - Public Methods
    
    func setup(with delegate: FeedViewDelegate) {
        tableView.register(UINib(nibName: FeedCell.nibName, bundle: Bundle.main),
                           forCellReuseIdentifier: FeedCell.nibName)
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.loadNews()
    }
}

extension FeedView: FeedViewModelDelegate {
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

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.nibName, for: indexPath) as? FeedCell else { fatalError("Cell is not of type \(FeedCell.nibName)!") }
        cell.setup(viewModel: viewModel.viewModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 1 else { return }
        delegate?.didTap(with: viewModel.viewModel(for: indexPath))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.height
        let difference = maxOffset - currentOffset
        if difference > 0, difference < 80 {
            viewModel.loadNews(nextPage: true)
        }
    }
}
