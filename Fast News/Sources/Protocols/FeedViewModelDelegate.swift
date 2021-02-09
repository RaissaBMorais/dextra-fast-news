//
//  FeedViewModelDelegate.swift
//  Fast News
//
//  Created by Raissa Morais on 2/9/21.
//  Copyright © 2021 Lucas Moreton. All rights reserved.
//

import Foundation
import UIKit.UIView
import Toast_Swift

protocol FeedViewModelDelegate {
    func onLoading(_ loading: Bool)
    func onLoadSucessful()
    func onLoadFailed(with error: Error)
}

extension FeedViewModelDelegate where Self: UIView {
    func onLoadFailed(with error: Error) {
        DispatchQueue.main.async {
            var style = ToastStyle()
            style.messageAlignment = .center
            self.makeToast(error.localizedDescription, duration: 3.0, position: .bottom, style: style)
        }
    }
}
